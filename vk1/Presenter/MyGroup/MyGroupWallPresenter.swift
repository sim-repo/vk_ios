import Foundation

class MyGroupWallPresenter: PlainPresenterProtocols {
    
    var modelClass: AnyClass  {
        return Wall.self
    }
    
    var detailModel: ModelProtocol?
}



extension MyGroupWallPresenter: DetailPresenterProtocol {
    
    func setDetailModel(model: ModelProtocol) {
        self.detailModel = model
    }
    
    func getId() -> typeId? {
        guard let passed = detailModel
        else {
            catchError(msg: "MyGroupWallPresenter: getId(): modelPassedThrowSegue is null")
            return nil
        }
        return passed.getId()
    }
}
