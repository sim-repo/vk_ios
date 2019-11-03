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
        
        let p = presenter as! FriendWallPresenter
        guard let id = p.getFriend()?.getId()
        else {
            catchError(msg: "SynchronizerManager: viewDidLoad(): MyGroupDetailPresenter.getId() is nil")
            return
        }
        
        ApiVK.friendWallRequest(ownerId: id, onSuccess: onSuccess_PresenterCompletion, onError: SynchronizerManager.shared.getOnErrorCompletion())
    }
}

