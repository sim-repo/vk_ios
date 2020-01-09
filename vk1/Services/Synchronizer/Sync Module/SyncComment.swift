//import UIKit
//
//class SyncComment {
//
//    public static func doCommentGet(postId: Int, ownerId: Int, _ onSuccess: (([Comment]?)->Void)?, _ onError: ((String)->Void)? ) {
//         ApiVKService.commentRequest(postId: postId, ownerId: ownerId, onSuccess, onError )
//    }
//}
//


import UIKit

class SyncComment: SyncBaseProtocol {
    
    static let shared = SyncComment()
    private override init() {}
    
    public func getId() -> String {
         return ModuleEnum.comment.rawValue
    }
    
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: CommentPresenter.self)
        
        guard let p = presenter as? PullCommentPresenterProtocol
            else {
                Logger.catchError(msg: "SyncComment: sync(): presenter is not conformed PullCommentPresenterProtocol")
                return
        }
        
        let news = p.getNews()
        presenter.clearDataSource(id: news.getId())
        
        syncFromNetwork(presenter, news: news, dispatchCompletion)
    }
    
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol, news: News, _ dispatchCompletion: (()->Void)? = nil){
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
        
        ApiVKService.commentRequest(postId: news.getId(), ownerId: news.ownerId, onSuccess, onError)
    }
}

