import UIKit

class SyncGroupDetail {
    
    static let shared = SyncGroupDetail()
    private init() {}
    
    func sync(_ presenter: SynchronizedPresenterProtocol) {
        
        
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
        
        //load from disk
        if let detailGroup = RealmService.loadDetailGroup(filter: "id = \(id)"),
            !detailGroup.isEmpty {
            presenter.setFromPersistent(models: detailGroup)
            return
        }
        
        
        // run when all networks have done
        let onFinish_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
        
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse(completion: {
            onFinish_SyncCompletion(presenter)
        })
        
       
        
        ApiVK.detailGroupRequest(group_id: id,
                                 onSuccess: onSuccess_PresenterCompletion,
                                 onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
