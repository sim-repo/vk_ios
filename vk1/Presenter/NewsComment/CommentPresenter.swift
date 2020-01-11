import Foundation

class CommentPresenter: PlainPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    var modelClass: AnyClass  {
        return Comment.self
    }
    
    var news: News!
    var parentModel: ModelProtocol? // deprecated
    
    
    //MARK: override func
    override func enrichData(validated: [PlainModelProtocol]) -> [PlainModelProtocol]? {
        
        for element in validated {
            let comment = element as! Comment
            comment.newsSourceId = news.ownerId
            comment.newsPostId = news.id
        }
        return validated
    }
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
    
    func didPressShowLikes() {
        let indexPath = IndexPath(row: 1, section: 0)
        view?.runPerformSegue(segueId: ModuleEnum.SegueIdEnum.postLikes.rawValue, indexPath)
    }
}
