import UIKit


// Responsible for making such decisions as:
// 1. what and when will be synchronized
// 2. sync sequences
// 3. decline sync

// well knows about presenters

class SynchronizerManager {
    
    static let shared = SynchronizerManager()
    private init() {}
    var wallSyncing = false
    
    var dispatchGroup: DispatchGroup?
    
    // called from PresenterFactory
    public func viewDidLoad(presenter: PresenterProtocol?, _ completion: (()->Void)? = nil){
        switch presenter {
            
               case is LoginPresenter:
                    syncWall(force: true)
            
               case is BasicNetworkProtocol:
                   let p = presenter as! BasicNetworkProtocol
                   if p.datasourceIsEmpty() {
                        p.loadFromNetwork(completion: completion)
                   }
            
               case is MyGroup:
                    let p = presenter as! MyGroupPresenter
                    if p.datasourceIsEmpty() {
                        syncMyGroup(p)
                    }
               
               case is WallPresenter:
                   syncWall(force: false)
            
               case is MyGroupDetailPresenter:
                   let p = presenter as! MyGroupDetailPresenter
                   syncGroupDetail(p)
            
               default:
                   catchError(msg: "SynchronizerManager: presenterSetup: no presenter has found: \(String(describing: presenter))")
        }
    }
    
    
    private func getOnErrorCompletion(_ completion: (()-> Void)? = nil ) -> onErrSyncCompletion {
        let onError: onErrSyncCompletion = { (error) in
            completion?()
            catchError(msg: "\(error.domain)")
        }
        return onError
    }
    

    
    //MARK: private sync functions
    
    
    //MARK: FRIEND
    private func syncFriend(_ presenter: FriendPresenter,
                            _ completion: (()-> Void)? = nil ) {
        
        let onSuccessCompletion = presenter.didLoadFromNetwork(completion: {
            completion?()
        })
        ApiVK.friendRequest(onSuccess: onSuccessCompletion, onError: getOnErrorCompletion())
    }
    
    
    // MY GROUP
    private func syncMyGroup(_ presenter: MyGroupPresenter,
                             _ completion: (()-> Void)? = nil ) {
        
        let onSuccessPresenterCompletion = presenter.didLoadFromNetwork(completion: {
            completion?()
        })
        ApiVK.myGroupRequest(onSuccess: onSuccessPresenterCompletion, onError: getOnErrorCompletion())
    }
    
    
    // GROUP DETAIL
    private func syncGroupDetail(_ presenter: MyGroupDetailPresenter,
                                 _ completion: (()-> Void)? = nil ) {
        
        let onSuccessCompletion = presenter.didLoadFromNetwork(completion: {
            completion?()
        })
        guard let id = presenter.getGroup()?.getId()
        else {
            catchError(msg: "SynchronizerManager: viewDidLoad(): MyGroupDetailPresenter.getId() is nil")
            return
        }
        ApiVK.detailGroupRequest(group_id: id, onSuccess: onSuccessCompletion, onError: getOnErrorCompletion())
    }
    
    
    
    // WALL
    private func syncWall(force: Bool){
        
        if wallSyncing {
            return
        }
        wallSyncing = true
        
        
        dispatchGroup = DispatchGroup()
        console(msg: "SynchronizerManager: syncWall..")

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }


            // create or get exists presenter
            let friendPresenter: FriendPresenter = PresenterFactory.shared.getInstance()

            // start syncing
            if force || friendPresenter.datasourceIsEmpty() {
                friendPresenter.clearDataSource()
                self.dispatchGroup?.enter()
                self.syncFriend(friendPresenter) { [weak self] in
                   console(msg: "SynchronizerManager: syncWall: FriendPresenter - sync completed" )
                   self?.dispatchGroup?.leave()
                }
            }


            // create or get exists presenter
            let groupPresenter: MyGroupPresenter = PresenterFactory.shared.getInstance()

            // start syncing
            if force || groupPresenter.datasourceIsEmpty() {
                friendPresenter.clearDataSource()
                self.dispatchGroup?.enter()
                self.syncMyGroup(groupPresenter) { [weak self] in
                   console(msg: "SynchronizerManager: syncWall: GroupPresenter - sync completed" )
                   self?.dispatchGroup?.leave()
                }
            }

            // all sync has finished
            self.dispatchGroup?.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self = self else { return }

                self.dispatchGroup = nil
                
                let friendDS = friendPresenter.getDataSource()
                let groupDS = groupPresenter.getDataSource()


                guard friendDS.isEmpty == false || groupDS.isEmpty == false
                   else {
                       catchError(msg: "SynchronizerManager: syncWall: friend & group DS is null")
                       return
                   }

                // create or get exists presenter
                let wallPresenter: WallPresenter = PresenterFactory.shared.getInstance()

                
                guard wallPresenter.datasourceIsEmpty() || force
                    else {
                    return
                }
                

                // ids as parameters for wall-requests
                var ids:[Int] = []

                groupDS.forEach { model in
                   ids.append(-model.getId())
                }

                friendDS.forEach { model in
                   ids.append(model.getId())
                }
                
                
                self.dispatchGroup = DispatchGroup()

                wallPresenter.clearDataSource()

                
                let semaphore = DispatchSemaphore(value: 1)
                let queue = DispatchQueue.global(qos: .background)
                
                for _ in ids {
                     self.dispatchGroup?.enter()
                }
                // send requests
                queue.async {
                    for id in ids {
                        
                        // lock
                        semaphore.wait()
                       // self.dispatchGroup?.enter()
                        print(id)
                        let onSuccessCompletion = wallPresenter.didLoadFromNetwork(completion: { [weak self] in
                            //release:
                            self?.dispatchGroup?.leave()
                            semaphore.signal()
                        })
                        let onErrorCompletion = self.getOnErrorCompletion() { [weak self] in
                            //release:
                            self?.dispatchGroup?.leave()
                            semaphore.signal()
                        }
                        ApiVK.wallRequest(ownerId: id, onSuccess: onSuccessCompletion, onError: onErrorCompletion)
                        
                    }
                }

                // sort all data when all requests has done
                self.dispatchGroup?.notify(queue: DispatchQueue.main) {
                   console(msg: "SynchronizerManager: syncWall: sync completed!")
                   wallPresenter.sort()
                   self.wallSyncing = false
                }
        }
    }
}

           
}
