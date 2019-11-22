import UIKit

class SyncFriendWall: SyncBaseProtocol {
    
    static let shared = SyncFriendWall()
    private override init() {}
    
    var module: ModuleEnum {
        return ModuleEnum.friend_wall
    }
    
    let count = Network.wallResponseItemsPerRequest
    var offsetById = [typeId:Int]()
    
    private func getOffsetCompletion(id: typeId) -> (()->Void) {
        return { [weak self]  in
            self?.incrementOffset(id: id)
        }
    }
    
    
    private func incrementOffset(id: Int) {
        if offsetById[id] == nil {
            offsetById[id] = count
        } else {
            offsetById[id]! += count
        }
    }
    
    public func resetOffset(){
        offsetById = [:]
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

            //load from disk
            if let walls = RealmService.loadWall(filter: "ownerId = \(id) AND offset = \(offset)"),
              !walls.isEmpty {
                   presenter.setFromPersistent(models: walls)
                   incrementOffset(id: id)
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
         
        syncStart = Date()
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
         
        ApiVK.friendWallRequest(id,
                                offset,
                                count,
                                onSuccess,
                                onError,
                                offsetCompletion)
     }
}

