import UIKit

// #adapter
class SyncGroupDetailAdapter: SyncBaseProtocol {
    
    static let shared = SyncGroupDetailAdapter()
    private override init() {}
    
    public func getId() -> String {
         return ModuleEnum.my_group_detail.rawValue
    }
    
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        
        let presenter = PresenterFactory.shared.getInstance(clazz: MyGroupDetailPresenter.self) // #adapter : КЛИЕНТ
        
        guard let p = presenter as? DetailPresenterProtocol
            else {
                Logger.catchError(msg: "SyncFriendWall: sync(): presenter is not conformed DetailPresenterProtocol")
                return
        }
        
        guard let id = p.getId()
            else {
                Logger.catchError(msg: "SyncFriendWall: sync(): no id")
                return
        }
    
        
        //check update schedule
        let interval = Date().timeIntervalSince(getLastSyncDate() ?? Date.yesterday)
        if interval > NetworkConstant.maxIntervalBeforeCleanupDataSource {
             presenter.clearDataSource(id: id)
             syncing = true
             syncFromNetwork(presenter, id: id, dispatchCompletion)
             return
        }
        
        
        //load from disk
        if let details = RealmService.loadDetailGroup(filter: "id = \(id)"),
            !details.isEmpty {
            presenter.setFromPersistent(models: details)
            dispatchCompletion?()
            return
        }
        
        syncFromNetwork(presenter, id: id, dispatchCompletion)
    }
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol, id: typeId, _ dispatchCompletion: (()->Void)? = nil){
        
        // clear all
        syncStart = Date()
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion) // #adapter : КЛИЕНТСКИЙ CLOSURE
        
        // #adapter : ВЫЗОВ СЕРВИСА
        ApiVKService.detailGroupRequest(group_id: id, onSuccess: onSuccess, onError: onError)
    }
}

