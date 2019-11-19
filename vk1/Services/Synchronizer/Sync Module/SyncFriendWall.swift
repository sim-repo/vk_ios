import UIKit

class SyncFriendWall: SyncBaseProtocol {
    
    static let shared = SyncFriendWall()
    private override init() {}
    
    let queue = DispatchQueue.global(qos: .background)
    
    var module: ModuleEnum {
        return ModuleEnum.friend_wall
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
            
            
            if force {
                syncFromNetwork(presenter, id: id, dispatchCompletion)
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
            
            syncFromNetwork(presenter, id: id, dispatchCompletion)
        }
    }
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol,
                                 id: typeId,
                                 _ dispatchCompletion: (()->Void)? = nil){
         
         // clear all
         syncStart = Date()
        
         let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
         
         ApiVK.friendWallRequest(ownerId: id, onSuccess: onSuccess, onError: onError)
     }
}

