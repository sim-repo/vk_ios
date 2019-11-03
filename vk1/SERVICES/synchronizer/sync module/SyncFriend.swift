import UIKit

class SyncFriend {
    
    static let shared = SyncFriend()
    private init() {}
    
    
    func sync(_ presenter: SynchronizedPresenterProtocol,
              _ completion: (()->Void)? = nil ) {
        
        // run when all networks have done
        let finish_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
        
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            finish_SyncCompletion(presenter)
            completion?()
        })
        
        ApiVK.friendRequest(onSuccess: onSuccess_PresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
