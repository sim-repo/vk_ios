import UIKit

class SyncProfile {
    
    static let shared = SyncProfile()
    private init() {}
    
    func sync(_ presenter: SynchronizedPresenterProtocol) {
        
                // run when all networks have done
        let onFinish_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
        
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            onFinish_SyncCompletion(presenter)
        })
        //ApiVK.groupRequest(onSuccess: onSuccessPresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
