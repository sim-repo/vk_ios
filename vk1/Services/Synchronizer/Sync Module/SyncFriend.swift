import UIKit

class SyncFriend: SyncBaseProtocol {

    static let shared = SyncFriend()
    private override init() {}
    
    let queue = DispatchQueue.global(qos: .background)
    
    var module: ModuleEnum {
        return ModuleEnum.friend
    }
    
    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        
       // queue.sync {
            let presenter = PresenterFactory.shared.getInstance(clazz: FriendPresenter.self)
            
            if force {
                syncFromNetwork(presenter, dispatchCompletion)
                return
            }
            
        
            if !presenter.dataSourceIsEmpty() {
                dispatchCompletion?()
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
       // }
    }
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol, _ dispatchCompletion: (()->Void)? = nil){
        
        // clear all
        syncStart = Date()
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)

        ApiVK.friendRequest(onSuccess: onSuccess, onError: onError)
    }
}
    
