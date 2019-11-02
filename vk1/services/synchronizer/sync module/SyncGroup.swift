import UIKit

class SyncGroup {
    
    static let shared = SyncGroup()
    private init() {}
    
    func sync(_ presenter: GroupPresenter,
                     _ completion: (()-> Void)? = nil ) {
        
        let onSuccessPresenterCompletion = presenter.didLoadFromNetwork(completion: {
            completion?()
        })
        //ApiVK.groupRequest(onSuccess: onSuccessPresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
