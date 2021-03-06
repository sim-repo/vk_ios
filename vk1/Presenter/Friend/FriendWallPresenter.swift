import Foundation

class FriendWallPresenter: PlainPresenterProtocols {
    
    
    var netFinishViewReload: Bool = false
    
    var modelClass: AnyClass  {
        return Wall.self
    }
    
    var parentModel: ModelProtocol?
    
    var expandedIndexPath: IndexPath?
}



extension FriendWallPresenter: DetailPresenterProtocol {
    
    func setParentModel(model: ModelProtocol) {
        parentModel = model
        clearCache(id: getId(), predicateEnum: .notEqual)
    }
    
    func getId() -> typeId? {
        guard let passed = parentModel
        else {
            Logger.catchError(msg: "FriendWallPresenter: getId(): modelPassedThrowSegue is null")
            return nil
        }
        return passed.getId()
    }
}


extension FriendWallPresenter: PaginationPresenterProtocol {}



extension FriendWallPresenter: PullWallPresenterProtocol {
    
    func selectImage(indexPath: IndexPath, imageIdx: Int) {
        
        guard let wall = getData(indexPath: indexPath) as? Wall
            else {
                Logger.catchError(msg: "FriendWallPresenter(): PullWallPresenterProtocol(): selectImage: getData exception ")
                return
            }
        
       // let url = wall.getImageURLs()[imageIdx]
     
        guard let view_ = view as? PushWallViewProtocol
            else {
                Logger.catchError(msg: "FriendWallPresenter(): PullWallPresenterProtocol(): selectImage: protocol conformation exception")
                return
            }
        view_.runPerformSegue(segueId: "FriendPostSegue", wall, selectedImageIdx: imageIdx)
    }
    
    func expandCell(isExpand: Bool, indexPath: IndexPath?) {
        expandedIndexPath = isExpand ? indexPath : nil
    }
    
    func isExpandedCell(indexPath: IndexPath) -> Bool {
        return expandedIndexPath == indexPath
    }
    
    func didPressLike(indexPath: IndexPath) {
        // TODO
    }
    
    func didPressComment(indexPath: IndexPath) {
        // TODO
    }
    
    func didPressShare(indexPath: IndexPath) {
        // TODO
    }
    
}
