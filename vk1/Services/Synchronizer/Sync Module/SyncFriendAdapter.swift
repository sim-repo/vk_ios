import UIKit

// #adapter
class SyncFriendAdapter: SyncBaseProtocol {
    
    static let shared = SyncFriendAdapter()
    private override init() {}
    
    public func getId() -> String {
        return ModuleEnum.friend.rawValue
    }
    
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: FriendPresenter.self) // #adapter : КЛИЕНТ
        
        
        //check update schedule
        let interval = Date().timeIntervalSince(getLastSyncDate() ?? Date.yesterday)
        if interval > NetworkConstant.maxIntervalBeforeCleanupDataSource {
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
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion) // #adapter : КЛИЕНТСКИЙ CLOSURE
        
        // #adapter : ВЫЗОВ СЕРВИСА
        ApiVKService.friendRequest(onSuccess: onSuccess, onError: onError)
    }
}

