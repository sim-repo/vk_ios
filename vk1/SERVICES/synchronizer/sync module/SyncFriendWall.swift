import UIKit

class SyncFriendWall {

    static let shared = SyncFriendWall()
    private init() {}
    
    func sync(_ presenter: FriendWallPresenter,
              _ completion: (()-> Void)? = nil ) {
        
        let onSuccessPresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            completion?()
        })
     //   ApiVK.friendWallRequest(onSuccess: onSuccessPresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
