import Foundation

class PostLikesPresenter: PlainPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    var modelClass: AnyClass  {
        return Like.self
    }
    
    var comment: Comment!
    var parentModel: ModelProtocol? // deprecated
}


extension PostLikesPresenter: DetailPresenterProtocol {
    
    func getId() -> typeId? {
        return comment.getId()
    }
    
    func setParentModel(model: ModelProtocol) {
        guard let comment = model as? Comment
            else {
                Logger.catchError(msg: "PostLikesPresenter(): requestComment(): protocol conformation exception")
                return }
        clearCache()
        self.comment = comment
    }
}


extension PostLikesPresenter: PullPostLikesPresenterProtocol {
    func getComment() -> Comment {
        return comment
    }
}
