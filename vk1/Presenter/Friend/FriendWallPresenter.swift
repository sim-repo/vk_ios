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
        clearDataSource()
    }
    
    func getId() -> typeId? {
        guard let passed = parentModel
        else {
            catchError(msg: "FriendWallPresenter: getId(): modelPassedThrowSegue is null")
            return nil
        }
        return passed.getId()
    }
}


extension FriendWallPresenter: PaginationPresenterProtocol {
    
}
