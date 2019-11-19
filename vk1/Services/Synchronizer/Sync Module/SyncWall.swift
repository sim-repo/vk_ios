import UIKit

class SyncWall: SyncBaseProtocol {
    
    var syncing = false
    var dispatchGroup: DispatchGroup?
    
    static let shared = SyncWall()
    private override init() {}
    
    var module: ModuleEnum {
        return ModuleEnum.wall
    }
    

    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        
        if syncing {
            return
        }
        syncing = true
        
        
        dispatchGroup = DispatchGroup()
        console(msg: "SynchronizerManager: syncWall..")
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // start syncing
            self.dispatchGroup?.enter()
            SyncFriend.shared.sync() { [weak self] in
                console(msg: "SynchronizerManager: syncWall: FriendPresenter - sync completed" )
                self?.dispatchGroup?.leave()
            }
            
            
            self.dispatchGroup?.enter()
            SyncMyGroup.shared.sync() { [weak self] in
                console(msg: "SynchronizerManager: syncWall: GroupPresenter - sync completed" )
                self?.dispatchGroup?.leave()
            }
            
            
            // all sync has finished
            
            self.dispatchGroup?.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self = self else { return }
                
                self.dispatchGroup = nil
                
                let friendPresenter = PresenterFactory.shared.getInstance(clazz: FriendPresenter.self)
                let friendDS = friendPresenter.getDataSource()
                let groupPresenter = PresenterFactory.shared.getInstance(clazz: MyGroupPresenter.self)
                let groupDS = groupPresenter.getDataSource()
                
                
                guard friendDS.isEmpty == false || groupDS.isEmpty == false
                    else {
                        catchError(msg: "SynchronizerManager: syncWall: friend & group DS is null")
                        return
                }
                
                // create or get exists presenter
                let wallPresenter: WallPresenter = PresenterFactory.shared.getInstance()
                
                
                guard wallPresenter.dataSourceIsEmpty() || force
                    else {
                        return
                }
                
                
                // ids as parameters for wall-requests
                var ids:[typeId] = []
                
                groupDS.forEach { model in
                    ids.append(-model.getId())
                }
                
                friendDS.forEach { model in
                    ids.append(model.getId())
                }
                   
               
                // ids = [] // test
                
                
                //load from disk
                if let walls = RealmService.loadWall(),
                    !walls.isEmpty {
                    wallPresenter.setFromPersistent(models: walls)
                    return
                }
                
                
                self.dispatchGroup = DispatchGroup()
                
                wallPresenter.clearDataSource()
                
                
                let semaphore = DispatchSemaphore(value: 3)
                let queue = DispatchQueue.global(qos: .background)
                
                for _ in ids {
                    self.dispatchGroup?.enter()
                }
                // send requests
                queue.async {
                    for id in ids {
                        
                        // lock
                        semaphore.wait()

                        console(msg: "\(id)")
                        let onSuccessCompletion = wallPresenter.didSuccessNetworkResponse(completion: { [weak self] in
                            //release:
                            self?.dispatchGroup?.leave()
                            semaphore.signal()
                        })
                        let onErrorCompletion = SynchronizerManager.shared.getOnErrorCompletion() { [weak self] in
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
                    wallPresenter.didSuccessNetworkFinish()
                    self.syncing = false
                }
            }
        }
    }
    
}
