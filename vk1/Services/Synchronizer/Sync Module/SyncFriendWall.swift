import UIKit

class SyncFriendWall: SyncBaseProtocol {
    
    static let shared = SyncFriendWall()
    private override init() {}
    
    var module: ModuleEnum {
        return ModuleEnum.friend_wall
    }
    
    let count = Network.friendWallResponseItemsPerRequest
    var offsetById = [typeId:Int]()
    
    private func getOffsetCompletion(id: typeId) -> (()->Void) {
        let offsetCompletion: () -> Void = {[weak self]  in
            self?.incrementOffset(id: id)
        }
        return offsetCompletion
    }
    
    
    private func incrementOffset(id: Int) {
        if offsetById[id] == nil {
            offsetById[id] = count
        } else {
            offsetById[id]! += count
        }
    }
    
    
    func sync(force: Bool = false,
            _ dispatchCompletion: (()->Void)? = nil) {
        
            guard !syncing else { return }
        
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
            
        
            //prepare for network
            let offset = offsetById[id] ?? 0
            let offsetCompletion = getOffsetCompletion(id: id)
            
            
            //load from network
            if force {
                syncing = true
                syncFromNetwork(presenter, id, offset, offsetCompletion, dispatchCompletion)
                return
            }

            //exit
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
        
            //load from network
            syncing = true
            syncFromNetwork(presenter, id, offset, offsetCompletion, dispatchCompletion)
    }
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol,
                                 _ id: typeId,
                                 _ offset: Int,
                                 _ offsetCompletion: (() -> Void)?,
                                 _ dispatchCompletion: (()->Void)? = nil){
         
         // clear all
         syncStart = Date()
        
         let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
         
        ApiVK.friendWallRequest(ownerId: id,
                                offset: offset,
                                count: count,
                                onSuccess: onSuccess,
                                onError: onError,
                                offsetCompletion: offsetCompletion)
     }
}

