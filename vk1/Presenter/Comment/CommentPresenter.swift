import Foundation

class CommentPresenter: PlainPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    var modelClass: AnyClass  {
        return Comment.self
    }
    
    var news: News!
    var comments: [Comment]?
    var parentModel: ModelProtocol? // deprecated
}


extension CommentPresenter: DetailPresenterProtocol {
    
    func getId() -> typeId? {
        return news.getId()
    }
    
    func setParentModel(model: ModelProtocol) {
        guard let news = model as? News
            else {
                Logger.catchError(msg: "CommentPresenter(): requestComment(): protocol conformation exception")
                return }
        clearCache()
        self.news = news
    }
}


extension CommentPresenter: PullCommentPresenterProtocol {
    
    func getNews() -> News {
        return news
    }
}
