import UIKit

class SyncMyGroupWall: SyncBaseProtocol {
    
    static let shared = SyncMyGroupWall()
    private override init() {}
    let queue = DispatchQueue.global(qos: .background)
    
    var module: ModuleEnum {
        return ModuleEnum.my_group_wall
    }
    
    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        
        queue.sync {
            let presenter = PresenterFactory.shared.getInstance(clazz: MyGroupWallPresenter.self)

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
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol, id: typeId, _ dispatchCompletion: (()->Void)? = nil){
            
        // clear all
        syncStart = Date()

        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)

        ApiVK.wallRequest(ownerId: -abs(id), onSuccess: onSuccess, onError: onError)
    }
}


