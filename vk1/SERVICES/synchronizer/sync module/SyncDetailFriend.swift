import UIKit

class SyncDetailFriend {

    static let shared = SyncDetailFriend()
    private init() {}
    
    
    func sync(_ presenter: DetailFriendPresenter,
              _ completion: (()-> Void)? = nil ) {
        
        let onSuccessPresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            completion?()
        })
        //ApiVK.friendDetailRequest(onSuccess: onSuccessPresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
