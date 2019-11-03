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
        
        let p = presenter as! MyGroupDetailPresenter
        guard let id = p.getGroup()?.getId()
        else {
            catchError(msg: "SynchronizerManager: viewDidLoad(): MyGroupDetailPresenter.getId() is nil")
            return
        }
        
        ApiVK.detailGroupRequest(group_id: id,
                                 onSuccess: onSuccess_PresenterCompletion,
                                 onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
