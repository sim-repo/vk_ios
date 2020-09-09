import UIKit

// #adapter
class SyncMyGroupWallAdapter: SyncBaseProtocol {
    
    static let shared = SyncMyGroupWallAdapter()
    private override init() {}

    var id: typeId = 0
    
    public func getId() -> String {
        return ModuleEnum.my_group_wall.rawValue + "\(id)"
    }
    
    var offsetById = [typeId:Int]()
    
    let count = NetworkConstant.wallResponseItemsPerRequest
    
    
    private func getOffsetCompletion(id: typeId) -> (()->Void) {
        return { [weak self]  in
            self?.incrementOffset(id: id)
            self?.syncing = false
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
    
    // #adapter : КЛИЕНТ
    var presenter: SynchronizedPresenterProtocol {
        return PresenterFactory.shared.getInstance(clazz: MyGroupWallPresenter.self)
    }
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
            guard !syncing else { return }
            
            guard let p = presenter as? DetailPresenterProtocol
            else {
               Logger.catchError(msg: "SyncMyGroupWall: sync(): presenter is not conformed DetailPresenterProtocol")
               return
            }
            
            guard let id_ = p.getId()
            else {
                Logger.catchError(msg: "SyncMyGroupWall: sync(): no id")
                return
            }
        
            id = id_
            
            let offset = offsetById[id] ?? 0
            let offsetCompletion = getOffsetCompletion(id: id)
            
        
            //check update schedule
            if offset == 0 {
                let interval = Date().timeIntervalSince(getLastSyncDate() ?? Date.yesterday)
                if interval > NetworkConstant.maxIntervalBeforeCleanupDataSource {
                     presenter.clearDataSource(id: id)
                     syncing = true
                     syncFromNetwork(presenter, id, offset, offsetCompletion, dispatchCompletion)
                     return
                 } else if interval > NetworkConstant.minIntervalBeforeSendRequest {
                     syncing = true
                     syncFromNetwork(presenter, id, 10, offsetCompletion, dispatchCompletion)
                     return
                 }
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

        syncStart = Date()

        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion) // #adapter : КЛИЕНТСКИЙ CLOSURE

        // #adapter : ВЫЗОВ СЕРВИСА
        ApiVKService.wallRequest(-abs(id),
                          onSuccess,
                          onError,
                          offsetCompletion,
                          offset
                          )
    }
}


