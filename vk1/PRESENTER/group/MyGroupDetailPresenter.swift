import Foundation
import Alamofire

class MyGroupDetailPresenter: PlainPresenterProtocols {
    
    var modelClass: AnyClass  {
        return DetailGroup.self
    }
       
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
    override func save(validated: [PlainModelProtocol]) {
        let detailGroup = validated[0] as! DetailGroup
        guard let gr = group
        else {
            catchError(msg: "MyGroupDetailPresenter: saveModel(): group is nil")
            return
        }
        detailGroup.setup(group: gr)
        super.didSave()
    }
}
