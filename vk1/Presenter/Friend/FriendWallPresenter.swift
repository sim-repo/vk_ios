import Foundation

class FriendWallPresenter: PlainPresenterProtocols {
    
    var modelClass: AnyClass  {
        return Wall.self
    }
    
    var detailModel: ModelProtocol?
}



extension FriendWallPresenter: DetailPresenterProtocol {
    
    func setDetailModel(model: ModelProtocol) {
        detailModel = model
        clearDataSource()
    }
    
    func getId() -> typeId? {
        guard let passed = detailModel
        else {
            catchError(msg: "FriendWallPresenter: getId(): modelPassedThrowSegue is null")
            return nil
        }
        return passed.getId()
    }
}


extension FriendWallPresenter: PaginationPresenterProtocol {
    
}
