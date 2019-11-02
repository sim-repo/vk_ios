import UIKit

class SyncFriend {
    
    static let shared = SyncFriend()
    private init() {}
    
    
    func sync(_ presenter: FriendPresenter,
              _ completion: (()-> Void)? = nil ) {
        
        let onSuccessCompletion = presenter.didLoadFromNetwork(completion: {
            completion?()
        })
        ApiVK.friendRequest(onSuccess: onSuccessCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
