import UIKit

class SyncMyGroup {

    static let shared = SyncMyGroup()
    private init() {}
    
    func sync(_ presenter: MyGroupPresenter,
              _ completion: (()-> Void)? = nil ) {
        
        let onSuccessPresenterCompletion = presenter.didLoadFromNetwork(completion: {
            completion?()
        })
        ApiVK.myGroupRequest(onSuccess: onSuccessPresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
