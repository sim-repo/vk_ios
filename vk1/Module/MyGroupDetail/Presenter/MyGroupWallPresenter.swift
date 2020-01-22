import Foundation

class MyGroupWallPresenter: PlainBasePresenter, ModulablePresenterProtocol {
    
    var netFinishViewReload: Bool = true
    
    var module: ModuleEnum = .myGroupWall
    
    var modelClass: ModelProtocol.Type  {
        return Wall.self
    }
    
    var myGroup: MyGroup? // needed for network api request
    
    var expandedIndexPath: IndexPath?
}

extension MyGroupWallPresenter: PaginablePresenterProtocol {}
 
extension MyGroupWallPresenter: ViewableWallPresenterProtocol {
    
    func didPressLike(indexPath: IndexPath) {
        // TODO: must implemented
    }
    
    func didPressComment(indexPath: IndexPath) {
        // TODO: must implemented
    }
    
    func didPressShare(indexPath: IndexPath) {
        // TODO: must implemented
    }
    
    func didSelectImage(indexPath: IndexPath, imageIdx: Int) {
        // TODO: must implemented
    }

    func didPressExpandCell(isExpand: Bool, indexPath: IndexPath?) {
        expandedIndexPath = isExpand ? indexPath : nil
    }
    
    func isExpandedCell(indexPath: IndexPath) -> Bool {
        return expandedIndexPath == indexPath
    }
}
