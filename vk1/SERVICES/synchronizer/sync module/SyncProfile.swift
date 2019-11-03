import UIKit

class SyncProfile {
    
    static let shared = SyncProfile()
    private init() {}
    
    func sync(_ presenter: ProfilePresenter,
                     _ completion: (()-> Void)? = nil ) {
        
        let onSuccessPresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            completion?()
        })
        //ApiVK.groupRequest(onSuccess: onSuccessPresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
