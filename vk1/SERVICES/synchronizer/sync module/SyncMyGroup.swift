import UIKit

class SyncMyGroup {

    static let shared = SyncMyGroup()
    private init() {}
    
    func sync(_ presenter: SynchronizedPresenterProtocol,
              _ completion: (()->Void)? = nil ) {
        
        // run when all networks have done
        let onFinish_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
        
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            onFinish_SyncCompletion(presenter)
            completion?()
        })
        
        ApiVK.myGroupRequest(onSuccess: onSuccess_PresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
