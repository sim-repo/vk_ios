import Foundation


public class PlainBasePresenter: BaseIndexingPresenter {
    
    override func viewReloadData(){
        getView()?.viewReloadData(moduleEnum: getModule())
        waitIndicator(start: false)
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "PlainBasePresenter: \(self.clazz): ", msg, level: level, printEnum: .presenter)
    }
    
    func getView() -> PresentablePlainViewProtocol? {
       guard let view = view as? PresentablePlainViewProtocol
       else {
           log("getView() \(String(describing: self.view)) doesn't conform protocol PresentablePlainViewProtocol", level: .error)
           return nil
       }
        return view
    }
}



