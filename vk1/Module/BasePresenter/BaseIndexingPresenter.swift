import Foundation


public class BaseIndexingPresenter: BasePresenter {
    
    var dataSource: [ModelProtocol] = []
    
    var clazz: String {
        return String(describing: self)
    }
    
    var paginationInProgess = false
    
    weak var view: PresentableViewProtocol?
    
    weak var synchronizer: PresentableSyncProtocol?
    
    
    //MARK:- initial
    
    // when view is not exists
    required override init() {
        super.init()
        
        guard let _ = self as? ModulablePresenterProtocol & SyncablePresenterParametersProtocol
        else {
            fatalError("BaseIndexingPresenter: \(clazz): init(): all protocols must be implemented")
        }
    }
    
    func getModule() -> ModuleEnum {
        (self as! ModulablePresenterProtocol).module
    }
    
    // MARK:- incoming model flow
    // network -> synchronizer -> presenter:
    // appendDataSource() -> validate() -> enrichData() -> save()
    
    
    final func appendDataSource(dirtyData: [ModelProtocol], didLoadedFrom: SyncConstant.ModelLoadedFromEnum) {
        
        guard let validated = validate(dirtyData)
            else {
                log("appendDataSource(): no valid data", level: .error)
                return
        }
        
        for model in validated {
            if !dataSource.contains(where: {$0.getId() == model.getId()}){
                dataSource.append(model)
            }
        }
        
        if didLoadedFrom == .network {
            (self as? EnrichablePresenterProtocol)?.enrichData(datasource: validated)
            save(validated)
        }
    }
    
    final func clearCache(id: Int? = nil, predicateEnum: LogicPredicateEnum? = nil){
        if let id_ = id, let predicate = predicateEnum {
            switch predicate {
            case .equal:
                dataSource.removeAll(where: {$0.getId() == id_})
            case .notEqual:
                dataSource.removeAll(where: {$0.getId() != id_})
            }
        } else {
            dataSource.removeAll()
        }
    }
    
    // check if datasource is conformed to model expected
    final func validate(_ dirtyData: [ModelProtocol]) -> [ModelProtocol]? {
        guard dirtyData.count > 0
            else {
                log("validate(): datasource is empty", level: .error)
                return nil
        }
        
        let required = "\((self as! ModulablePresenterProtocol).modelClass)"
        let current = getRawClassName(object: type(of: dirtyData[0]))
        guard required == current
            else {
                log("validate(): returned datasource incorrected", level: .error)
                return nil
        }
        return dirtyData
    }
    
    
    func viewReloadData(){
        log("Overriding Error: this method must be overriding by child classes", level: .error)
    }
    
    
    final func save(_ datasource: [ModelProtocol]) {
        RealmService.save(models: datasource, update: true)
    }
    
    final func waitIndicator(start: Bool) {
        if start {
            view?.startWaitIndicator(getModule())
        } else {
            view?.stopWaitIndicator(getModule())
        }
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "BasePresenter: \(self.clazz): ", msg, level: level, printEnum: .presenter)
    }
}
