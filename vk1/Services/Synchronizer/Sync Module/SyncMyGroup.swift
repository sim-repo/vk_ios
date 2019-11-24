import UIKit

class SyncMyGroup: SyncBaseProtocol {
    
    static let shared = SyncMyGroup()
    private override init() {}
    
    public func getId() -> String {
        return ModuleEnum.my_group.rawValue
    }
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: MyGroupPresenter.self)
        
        
        //check update schedule
        let interval = Date().timeIntervalSince(getLastSyncDate() ?? Date.yesterday)
        if interval > Network.maxIntervalBeforeCleanupDataSource {
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
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
        
        ApiVK.myGroupRequest(onSuccess: onSuccess, onError: onError)
    }
}

