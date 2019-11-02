import UIKit

class SyncGroupDetail {
    
    static let shared = SyncGroupDetail()
    private init() {}
    
    func sync(_ presenter: MyGroupDetailPresenter,
              _ completion: (()-> Void)? = nil ) {
        
        let onSuccessCompletion = presenter.didLoadFromNetwork(completion: {
            completion?()
        })
        guard let id = presenter.getGroup()?.getId()
        else {
            catchError(msg: "SynchronizerManager: viewDidLoad(): MyGroupDetailPresenter.getId() is nil")
            return
        }
        ApiVK.detailGroupRequest(group_id: id, onSuccess: onSuccessCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}
    
