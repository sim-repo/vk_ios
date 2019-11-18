import UIKit

class SyncMyGroup {

    static let shared = SyncMyGroup()
    private init() {}
    
    func sync(_ presenter: SynchronizedPresenterProtocol,
              _ completion: (()->Void)? = nil ) {
        
        
        
        //load from disk
        if let groups = RealmService.loadMyGroup(),
            !groups.isEmpty {
            presenter.setFromPersistent(models: groups)
            completion?()
            return
        }
        
        // run when all networks have done
        let onFinish_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
        
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            onFinish_SyncCompletion(presenter)
            completion?()
        })
        
        ApiVK.myGroupRequest(onSuccess: onSuccess_PresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
