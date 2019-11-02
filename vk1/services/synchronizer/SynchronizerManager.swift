import UIKit


// Responsible for making such decisions as:
// 1. what and when will be synchronized
// 2. sync sequences
// 3. decline sync

// well knows about presenters

class SynchronizerManager {
    
    static let shared = SynchronizerManager()
    private init() {}
    
    // called from PresenterFactory
//    public func viewDidLoad(presenter: PresenterProtocol?, _ completion: (()->Void)? = nil){
//
//        switch presenter {
//               case is LoginPresenter:
//                    let p = presenter as! LoginPresenter
//                    SyncLogin.sync(p, completion)
//
//
//               case is MyGroupPresenter:
//                    let p = presenter as! MyGroupPresenter
//                    if p.dataSourceIsEmpty() {
//                        syncMyGroup(p)
//                    }
//
//               case is MyGroupDetailPresenter:
//                    let p = presenter as! MyGroupDetailPresenter
//                    syncGroupDetail(p)
//
//               case is FriendPresenter:
//                    let p = presenter as! FriendPresenter
//                    syncFriend(p)
//
//               case is WallPresenter:
//                   syncWall(force: false)
//
//               default:
//                   catchError(msg: "SynchronizerManager: presenterSetup: no presenter has found: \(String(describing: presenter))")
//        }
//    }
//
//
    
    public func viewDidLoad(presenterEnum: PresenterEnum, _ completion: (()->Void)? = nil){
        
        switch presenterEnum {
        
        case .friendPresenter:
            let p: FriendPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncFriend.shared.sync(p, completion)
            }
            
        case .detailFriendPresenter:
            let p: DetailFriendPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncDetailFriend.shared.sync(p, completion)
            }
            
        case .myGroupPresenter:
            let p: MyGroupPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncMyGroup.shared.sync(p, completion)
            }
            
        case .myGroupDetailPresenter:
            let p: MyGroupDetailPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncGroupDetail.shared.sync(p, completion)
            }
            
        case .groupPresenter:
            let p: GroupPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncGroup.shared.sync(p, completion)
            }
        
        case .wallPresenter:
            let p: WallPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncWall.shared.sync(force: false)
            }

        case .friendWallPresenter:
            let p: FriendWallPresenter =  PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncFriendWall.shared.sync(p, completion)
            }
            
        case .profilePresenter:
            let p: ProfilePresenter = PresenterFactory.shared.getInstance()
            SyncProfile.shared.sync(p, completion)
            
        case .loginPresenter:
            SyncLogin.shared.sync(force: true)
        }
    }
    
    
    func getOnErrorCompletion(_ completion: (()-> Void)? = nil ) -> onErrSyncCompletion {
        let onError: onErrSyncCompletion = { (error) in
            completion?()
            catchError(msg: "\(error.domain)")
        }
        return onError
    }
        
}
