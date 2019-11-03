import UIKit

class SyncFriendWall {

    static let shared = SyncFriendWall()
    private init() {}
    
    func sync(_ presenter: SynchronizedPresenterProtocol) {
        
       // run when all networks have done
       let onFinish_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
       
       let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
           onFinish_SyncCompletion(presenter)
       })
        
     //   ApiVK.friendWallRequest(onSuccess: onSuccessPresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
