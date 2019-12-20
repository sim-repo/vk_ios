import Foundation

class FriendWallPresenter: PlainPresenterProtocols {
    
    
    var netFinishViewReload: Bool = false
    
    var modelClass: AnyClass  {
        return Wall.self
    }
    
    var parentModel: ModelProtocol?
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


extension FriendWallPresenter: PaginationPresenterProtocol {
    
}



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
                Logger.catchError(msg: "FriendWallPresenter(): PullWallPresenterProtocol(): selectImage: protocol conform exception")
                return
            }
        view_.runPerformSegue(segueId: "FriendPostSegue", wall, selectedImageIdx: imageIdx)
    }
}
