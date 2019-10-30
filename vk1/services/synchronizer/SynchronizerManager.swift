import UIKit


// Responsible for making such decisions as:
// 1. what and when will be synchronized
// 2. sync sequences
// 3. decline sync

// well knows about presenters

class SynchronizerManager {
    
    static let shared = SynchronizerManager()
    private init() {}
    
    var dispatchGroup: DispatchGroup?
    
    
    public func startSync(force: Bool){
        
        dispatchGroup = DispatchGroup()
        console(msg: "SynchronizerManager: startSync..")
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
        
            // network loading
            let friendPresenter: FriendPresenter = PresenterFactory.shared.getInstance()
            if force || friendPresenter.datasourceIsEmpty() {
                self.dispatchGroup?.enter()
                friendPresenter.loadFromNetwork(){
                    console(msg: "SynchronizerManager: startSync: FriendPresenter - sync completed" )
                    self.dispatchGroup?.leave()
                }
            }
            
            // network loading
            let groupPresenter: MyGroupPresenter = PresenterFactory.shared.getInstance()
            if force || groupPresenter.datasourceIsEmpty() {
                self.dispatchGroup?.enter()
                groupPresenter.loadFromNetwork(){
                    console(msg: "SynchronizerManager: startSync: GroupPresenter - sync completed" )
                    self.dispatchGroup?.leave()
                }
            }

            // all sync had finished
            self.dispatchGroup?.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self = self else { return }
                
                self.dispatchGroup = nil
                
                let friendPresenter: FriendPresenter? = PresenterFactory.shared.getPresenter()
                let friendDS = friendPresenter?.getDataSource()
                
                let groupPresenter: MyGroupPresenter? = PresenterFactory.shared.getPresenter()
                let groupDS = groupPresenter?.getDataSource()
                
                
                var ids:[Int] = []
//                friendDS?.forEach { model in
//                    ids.append(model.getId())
//                }
                
                groupDS?.forEach { model in
                    ids.append(model.getId())
                }
                
                
                let wallPresenter: WallPresenter = PresenterFactory.shared.getInstance()
                wallPresenter.clearDataSource()
                for id in ids {
                    wallPresenter.loadFromNetwork(ownerId: id) {
                        print("syncing..")
                    }
                }
                //console(msg: "SynchronizerManager: startSync: sync completed!")
            }
        }
    }
    
    
    public func viewDidLoad(vc: ViewProtocol, _ completion: (()->Void)? = nil) {
        switch vc {
               case is LoginViewController:
                   startSync(force: true)
               default:
                    break
        }
    }
    
    // called from PresenterFactory
    public func presenterSetup(presenter: PresenterProtocol?, _ completion: (()->Void)? = nil){
        switch presenter {
               case is BasicNetworkProtocol:
                   let p = presenter as! BasicNetworkProtocol
                   if p.datasourceIsEmpty() {
                        p.loadFromNetwork(completion: completion)
                    }
               case is WallPresenter:
                   let p = presenter as! WallPresenter
                   if p.datasourceIsEmpty() {
                      startSync(force: false)
                   }
               default:
                   catchError(msg: "SynchronizerManager: presenterSetup: no presenter has found: \(String(describing: presenter))")
        }
    }
}
