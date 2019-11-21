import UIKit

class SyncMyGroupWall: SyncBaseProtocol {
    
    static let shared = SyncMyGroupWall()
    private override init() {}

    var module: ModuleEnum {
        return ModuleEnum.my_group_wall
    }
    
    var offsetById = [typeId:Int]()
    
    let count = Network.friendWallResponseItemsPerRequest
    
    private func getOffsetCompletion(id: typeId) -> (()->Void) {
        let offsetCompletion: () -> Void = {[weak self]  in
            self?.incrementOffset(id: id)
            self?.syncing = false
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
            
            let presenter = PresenterFactory.shared.getInstance(clazz: MyGroupWallPresenter.self)

            guard let p = presenter as? DetailPresenterProtocol
            else {
               catchError(msg: "SyncMyGroupWall: sync(): presenter is not conformed DetailPresenterProtocol")
               return
            }
            
            guard let id = p.getId()
            else {
                catchError(msg: "SyncMyGroupWall: sync(): no id")
                return
            }
            
            let offset = offsetById[id] ?? 0
            let offsetCompletion = getOffsetCompletion(id: id)
            
            if force {
                syncing = true
                syncFromNetwork(presenter, id, offset, offsetCompletion, dispatchCompletion)
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
            syncing = true
            syncFromNetwork(presenter, id, offset, offsetCompletion, dispatchCompletion)
    }
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol,
                                 _ id: typeId,
                                 _ offset: Int,
                                 _ offsetCompletion: (()->Void)?,
                                 _ dispatchCompletion: (()->Void)? = nil){
            
        // clear all
        syncStart = Date()

        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)

        ApiVK.wallRequest(ownerId: -abs(id),
                          onSuccess: onSuccess,
                          onError: onError,
                          offsetCompletion: offsetCompletion)
    }
}


