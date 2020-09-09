import UIKit

// #adapter
class SyncMyGroupAdapter: SyncBaseProtocol {
    
    static let shared = SyncMyGroupAdapter()
    private override init() {}
    
    public func getId() -> String {
        return ModuleEnum.my_group.rawValue
    }
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: MyGroupPresenter.self) // #adapter : КЛИЕНТ
        
        
        //check update schedule
        let interval = Date().timeIntervalSince(getLastSyncDate() ?? Date.yesterday)
        if interval > NetworkConstant.maxIntervalBeforeCleanupDataSource {
             presenter.clearDataSource(id: nil)
             syncing = true
             syncFromNetwork(presenter, dispatchCompletion)
             return
        }
        
        //load from disk
        if let groups = RealmService.loadMyGroup(),
            !groups.isEmpty {
            presenter.setFromPersistent(models: groups)
            dispatchCompletion?()
            return
        }
        syncFromNetwork(presenter, dispatchCompletion)
        
    }
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol, _ dispatchCompletion: (()->Void)? = nil){
        
        // clear all
        syncStart = Date()
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion) // #adapter : КЛИЕНТСКИЙ CLOSURE
        
        // #adapter : ВЫЗОВ СЕРВИСА
        ApiVKService.myGroupRequest(onSuccess: onSuccess, onError: onError)
    }
}

