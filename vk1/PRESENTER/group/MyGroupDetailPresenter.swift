import Foundation
import Alamofire

class MyGroupDetailPresenter: PlainPresenterProtocols {
    
    var modelClass: AnyClass  {
        return DetailGroup.self
    }
       
    var detailModel: ModelProtocol?
    
    
    override func viewDidDisappear() {
        clearDataSource()
    }
    
    
    //MARK: override func
    override func save(validated: [PlainModelProtocol]) {
        let detailGroup = validated[0] as! DetailGroup
        guard let group = detailModel as? MyGroup
        else {
            catchError(msg: "MyGroupDetailPresenter: save(): detailModel is incorrect")
            return
        }
        detailGroup.setup(group: group)
        super.didSave()
    }
}


extension MyGroupDetailPresenter: DetailPresenterProtocol {
    
    func setDetailModel(model: ModelProtocol) {
        self.detailModel = model
    }
    
    func getId() -> typeId? {
        guard let passed = detailModel
        else {
            catchError(msg: "MyGroupDetailPresenter: getId(): modelPassedThrowSegue is null")
            return nil
        }
        return passed.getId()
    }
}
