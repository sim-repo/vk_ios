import UIKit

class SyncMyGroupWall {
    
    static let shared = SyncMyGroupWall()
    private init() {}
    
    func sync(_ presenter: SynchronizedPresenterProtocol) {
        
        // run when all networks have done
        let onFinish_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
        
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            onFinish_SyncCompletion(presenter)
        })
        
        guard let p = presenter as? DetailPresenterProtocol
        else {
            catchError(msg: "SyncMyGroupWall: sync(): presenter is not conformed DetailPresenterProtocol")
            return
        }

        guard let id = p.getId()
        else {
            catchError(msg: "SyncMyGroupWall: sync(): no id")
            return
        }
        
        let formattedId = -abs(id)
        ApiVK.wallRequest(ownerId: formattedId, onSuccess: onSuccess_PresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}


