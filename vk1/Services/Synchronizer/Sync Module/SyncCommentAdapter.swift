import UIKit

// #adapter
class SyncCommentAdapter: SyncBaseProtocol {
    
    static let shared = SyncCommentAdapter()
    private override init() {}
    
    public func getId() -> String {
         return ModuleEnum.comment.rawValue
    }
    
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: CommentPresenter.self)
        
        guard let news = (presenter as? PullCommentPresenterProtocol)?.getNews()
            else {
                Logger.catchError(msg: "SyncComment: sync(): presenter is not conformed PullCommentPresenterProtocol")
                return
        }
        
        presenter.clearDataSource(id: news.getId())
        
        syncFromNetwork(presenter, news: news, dispatchCompletion)
    }
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol, news: News, _ dispatchCompletion: (()->Void)? = nil){
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
        
        ApiVKService.commentRequest(postId: news.getId(), ownerId: news.ownerId, onSuccess, onError)
    }
}

