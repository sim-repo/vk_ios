import UIKit

class SyncFriend: SyncBaseProtocol {
    
    static let shared = SyncFriend()
    private override init() {}
    
    public func getId() -> String {
        return ModuleEnum.friend.rawValue
    }
    
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: FriendPresenter.self)
        
        
        //check update schedule
        let interval = Date().timeIntervalSince(getLastSyncDate() ?? Date.yesterday)
        if interval > Network.maxIntervalBeforeCleanupDataSource {
            presenter.clearDataSource(id: nil)
             syncing = true
             syncFromNetwork(presenter, dispatchCompletion)
             return
        }
        
        //load from disk
        if let friends = RealmService.loadFriend(),
            !friends.isEmpty {
            presenter.setFromPersistent(models: friends)
            dispatchCompletion?()
            return
        }
        syncFromNetwork(presenter, dispatchCompletion)
    }
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol, _ dispatchCompletion: (()->Void)? = nil){
        
        // clear all
        syncStart = Date()
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
        
        ApiVKService.friendRequest(onSuccess: onSuccess, onError: onError)
    }
}

