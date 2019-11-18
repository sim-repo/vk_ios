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
        
        guard let p = presenter as? DetailPresenterProtocol
        else {
            catchError(msg: "SyncFriendWall: sync(): presenter is not conformed DetailPresenterProtocol")
            return
        }

        guard let id = p.getId()
        else {
            catchError(msg: "SyncFriendWall: sync(): no id")
            return
        }
        
        ApiVK.friendWallRequest(ownerId: id, onSuccess: onSuccess_PresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}

