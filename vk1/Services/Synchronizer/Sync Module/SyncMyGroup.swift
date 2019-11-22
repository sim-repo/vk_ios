import UIKit

class SyncMyGroup: SyncBaseProtocol {
    
    static let shared = SyncMyGroup()
    private override init() {}
    
    var module: ModuleEnum {
        return ModuleEnum.my_group
    }
    
    
    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: MyGroupPresenter.self)
        
        if force {
            syncFromNetwork(presenter, dispatchCompletion)
            return
        }
        
        
        if !presenter.dataSourceIsEmpty() {
            dispatchCompletion?()
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

