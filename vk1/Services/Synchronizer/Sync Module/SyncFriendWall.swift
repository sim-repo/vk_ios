import UIKit

class SyncFriendWall: SyncBaseProtocol {
    
    static let shared = SyncFriendWall()
    private override init() {}
    
    var offsetByFriendId = [typeId:Int]()
    
    let queue = DispatchQueue.global(qos: .background)
    
    var module: ModuleEnum {
        return ModuleEnum.friend_wall
    }
    
    let count = Network.friendWallResponseItemsPerRequest
    
    private func incrementOffset(id: Int) {
        if offsetByFriendId[id] == nil {
            offsetByFriendId[id] = count
        } else {
            offsetByFriendId[id]! += count
        }
    }
    
    
    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        
        queue.sync {
            let presenter = PresenterFactory.shared.getInstance(clazz: FriendWallPresenter.self)
            
            guard let p = presenter as? DetailPresenterProtocol
            else {
               catchError(msg: "SyncFriendWall: sync(): presenter is not conformed DetailPresenterProtocol")
               return
            }
            
            guard let id = p.getId()
            else {
                catchError(msg: "SyncFriendWall: sync(): no id")
                return
            }
            
            let offset = offsetByFriendId[id] ?? 0
            incrementOffset(id: id)
            
            
            if force {
                syncFromNetwork(presenter, id, offset, dispatchCompletion)
                return
            }

            
            if !presenter.dataSourceIsEmpty() {
               dispatchCompletion?()
               return
            }
            

            //load from disk
            if let walls = RealmService.loadWall(filter: "ownerId = \(id)"),
              !walls.isEmpty {
                   presenter.setFromPersistent(models: walls)
                   dispatchCompletion?()
                   return
            }
            
            syncFromNetwork(presenter, id, offset, dispatchCompletion)
        }
    }
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol,
                                 _ id: typeId,
                                 _ offset: Int,
                                 _ dispatchCompletion: (()->Void)? = nil){
         
         // clear all
         syncStart = Date()
        
         let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
         
        ApiVK.friendWallRequest(ownerId: id, offset: offset, count: count, onSuccess: onSuccess, onError: onError)
     }
}

