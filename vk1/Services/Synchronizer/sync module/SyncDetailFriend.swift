import UIKit

class SyncDetailFriend {

    static let shared = SyncDetailFriend()
    private init() {}
    
    
    func sync(_ presenter: SynchronizedPresenterProtocol,
              _ completion: (()-> Void)? = nil ) {
        
               // run when all networks have done
        let onFinish_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
        
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            onFinish_SyncCompletion(presenter)
        })
        //ApiVK.friendDetailRequest(onSuccess: onSuccessPresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
