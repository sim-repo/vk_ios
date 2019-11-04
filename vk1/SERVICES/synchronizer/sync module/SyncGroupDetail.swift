import UIKit

class SyncGroupDetail {
    
    static let shared = SyncGroupDetail()
    private init() {}
    
    func sync(_ presenter: SynchronizedPresenterProtocol) {
        
        // run when all networks have done
        let onFinish_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
        
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            onFinish_SyncCompletion(presenter)
        })
        
        guard let p = presenter as? DetailPresenterProtocol
        else {
            catchError(msg: "SyncDetailGroup: sync(): presenter is not conformed DetailPresenterProtocol")
            return
        }

        guard let id = p.getId()
        else {
            catchError(msg: "SyncDetailGroup: sync(): no id")
            return
        }
        
        ApiVK.detailGroupRequest(group_id: id,
                                 onSuccess: onSuccess_PresenterCompletion,
                                 onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
