import Foundation
import Alamofire

class FriendWallPresenter: PlainPresenterProtocols {
    
    var modelClass: AnyClass  {
        return Wall.self
    }
    
    var detailModel: ModelProtocol?
    
    var friend: Friend?
}



extension FriendWallPresenter: DetailPresenterProtocol {
    
    func setDetailModel(model: ModelProtocol) {
        self.detailModel = model
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
