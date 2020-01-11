import UIKit

class PostSyncLikes: SyncBaseProtocol {
    
    static let shared = PostSyncLikes()
    private override init() {}
    
    public func getId() -> String {
         return ModuleEnum.postLikes.rawValue
    }
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: PostLikesPresenter.self)
        
        guard let comment = (presenter as? PullPostLikesPresenterProtocol)?.getComment()
            else {
                Logger.catchError(msg: "PostSyncLikes: sync(): presenter is not conformed PullCommentPresenterProtocol")
                return
        }
        
        presenter.clearDataSource(id: comment.getId())
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
               
        ApiVKService.likesRequest(itemId: comment.newsPostId, comment.newsSourceId, .post, onSuccess, onError)
    }
    
}

