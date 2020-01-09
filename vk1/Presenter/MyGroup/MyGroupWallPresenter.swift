import Foundation

class MyGroupWallPresenter: PlainPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    var modelClass: AnyClass  {
        return Wall.self
    }
    
    var parentModel: ModelProtocol?
    
    var expandedIndexPath: IndexPath?
}



extension MyGroupWallPresenter: DetailPresenterProtocol {
    
    func setParentModel(model: ModelProtocol) {
        self.parentModel = model
    }
    
    func getId() -> typeId? {
        guard let passed = parentModel
            else {
                Logger.catchError(msg: "MyGroupWallPresenter: getId(): modelPassedThrowSegue is null")
                return nil
        }
        return passed.getId()
    }
}


extension MyGroupWallPresenter: PaginationPresenterProtocol {
    
}


extension MyGroupWallPresenter: PullWallPresenterProtocol {
    
    func selectImage(indexPath: IndexPath, imageIdx: Int) {
            let wall = getData(indexPath: indexPath) as? Wall
            let url = wall?.getImageURLs()[imageIdx]
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
