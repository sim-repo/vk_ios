import Foundation


class MyGroupDetailPresenter: PlainBasePresenter, ModulablePresenterProtocol {
    
    var module: ModuleEnum = .myGroupDetail
    
    var modelClass: ModelProtocol.Type {
        return MyGroupDetail.self
    }
    
    var netFinishViewReload: Bool = true
       
    var myGroup: MyGroup?
    
    var myGroupWallPresenter = MyGroupWallPresenter()

    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "MyGroupDetailPresenter: \(self.clazz): ", msg, level: level, printEnum: .presenter)
    }
}


extension MyGroupDetailPresenter: MultiplePresenterProtocol {
    func didSetView() {
        myGroupWallPresenter.setView(view: view!)
    }
}


extension MyGroupDetailPresenter: DetailablePresenterProtocol {
    
    func didSetMaster(master: ModelProtocol) {
        guard let group = master as? MyGroup
            else {  log("didSetMaster: downcasting error", level: .error)
                    return }
        myGroup = group
        myGroupWallPresenter.myGroup = myGroup
    }
    
    func enrichData(datasource: [ModelProtocol]) {
       let detailGroup = datasource[0] as! MyGroupDetail
       guard let group = myGroup
       else {
           Logger.catchError(msg: "\(clazz): enrichData(): detailModel is incorrect")
           return
       }
       detailGroup.myGroup = group
    }
}


extension MyGroupDetailPresenter: ViewableMyGroupDetailPresenterProtocol {
    func getMyGroupWallPresenter() -> ViewableWallPresenterProtocol {
        myGroupWallPresenter
    }
}
