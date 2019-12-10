import UIKit

class SyncFriendWall: SyncBaseProtocol {
    
    static let shared = SyncFriendWall()
    private override init() {}
    
    let count = NetworkConstant.wallResponseItemsPerRequest
    var offsetById = [typeId:Int]()
    
    var id: typeId = 0
    
    public func getId() -> String {
        return ModuleEnum.friend_wall.rawValue + "\(id)"
    }
    
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
    
    private func getOffset(_ id: Int) -> Int? {
        return offsetById[id]
    }
    
    public func resetOffset(){
        offsetById = [:]
    }
    
    
    var presenter: SynchronizedPresenterProtocol {
        return PresenterFactory.shared.getInstance(clazz: FriendWallPresenter.self)
    }
    
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
            guard !syncing else { return }
        
            guard let p = presenter as? DetailPresenterProtocol
            else {
                Logger.catchError(msg: "SyncFriendWall: sync(): presenter is not conformed DetailPresenterProtocol")
                return
            }
            
            guard let id_ = p.getId()
            else {
                Logger.catchError(msg: "SyncFriendWall: sync(): no id")
                return
            }
            
            id = id_
        
            //prepare for network
            let offset = getOffset(id) ?? 0
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
                     syncFromNetwork(presenter, id, 0, offsetCompletion, dispatchCompletion)
                     return
                 }
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
         
        ApiVKService.friendWallRequest(id,
                                offset,
                                count,
                                onSuccess,
                                onError,
                                offsetCompletion)
     }
}

