import Foundation
import Alamofire

public class MyGroupDetailPresenter: PlainBasePresenter {
       
    var group: MyGroup?

    
    
    func setGroup(group: MyGroup) {
        self.group = group
    }
    
    func getGroup() -> MyGroup? {
        return group
    }
    
    override func viewDidDisappear() {
        clearDataSource()
    }
    
    
    
    //MARK: override func

    override func saveModel(ds: [DecodableProtocol]) {
        let detailGroup = ds[0] as! DetailGroup
        guard let gr = group
        else {
            catchError(msg: "MyGroupDetailPresenter: saveModel(): group is nil")
            return
        }
        detailGroup.setup(group: gr)
        didSaveModel()
    }
    
    override func validate(_ ds: [DecodableProtocol]) {
        guard ds is [DetailGroup]
        else {
            catchError(msg: "MyGroupDetailPresenter: validate()")
            return
        }
    }
}
