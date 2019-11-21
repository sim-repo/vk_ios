import Foundation

class MyGroupWallPresenter: PlainPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    var modelClass: AnyClass  {
        return Wall.self
    }
    
    var parentModel: ModelProtocol?
}



extension MyGroupWallPresenter: DetailPresenterProtocol {
    
    func setParentModel(model: ModelProtocol) {
        self.parentModel = model
    }
    
    func getId() -> typeId? {
        guard let passed = parentModel
            else {
                catchError(msg: "MyGroupWallPresenter: getId(): modelPassedThrowSegue is null")
                return nil
        }
        return passed.getId()
    }
}


extension MyGroupWallPresenter: PaginationPresenterProtocol {
    
}
