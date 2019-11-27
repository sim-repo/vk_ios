import Foundation


public class PlainBasePresenter {

    var modelType: AnyClass?  {
        return nil
    }
    
    lazy var moduleEnum = ModuleEnum(presenter: self)
    
    
    weak var view: PushPlainViewProtocol? {
        willSet(newValue) {
            didSetViewCompletion?(newValue)
        }
    }
    
    var dataSource: [PlainModelProtocol] = []

    var clazz: String {
        return String(describing: self)
    }

    var didSetViewCompletion: ((PushPlainViewProtocol?)->Void)?

    var pageInProgess = false
    
    
    //MARK:- complex
    var subSectionPresenter: PullSectionPresenterProtocol?
    var subPlainPresenter: PullPlainPresenterProtocol?
    
    
    //MARK:- initial
    
    // when view is not exists
    required init() {}
    
    // init presenter and view simultaneously
    required convenience init?(vc: PushViewProtocol) {
        self.init()
        guard let _view = vc as? PushPlainViewProtocol
        else {
            log("init(vc:) - vc \(vc) doesn't conform protocol PushPlainViewProtocol", isErr: true)
            return
        }
        self.view = _view
    }
    
    
    final func validateView(_ vc: PushViewProtocol){
        guard let _ = vc as? PushPlainViewProtocol
        else {
            log("validateView(vc:) - incorrect passed vc", isErr: true)
            return
        }
    }
    

// MARK:- incoming model flow
// network -> synchronizer -> presenter:
// appendDataSource() -> validate() -> enrichData() -> viewReloadData() -> save()

    
    final func appendDataSource(dirtyData: [DecodableProtocol], didLoadedFrom: ModelLoadedFromEnum) {
         
        guard let validatedData = validate(dirtyData)
            else {
                   log("setModel(): no valid data", isErr: true)
                   return
           }
    
        for model in validatedData {
            if !dataSource.contains(where: {$0.getId() == model.getId()}){
                dataSource.append(model)
            }
        }
        
        switch didLoadedFrom {
            case .disk:
                return // data stored already
           case .network:
                if let enriched = enrichData(validated: validatedData) {
                    save(enriched: enriched)
                } else {
                    log("enriched data is empty", isErr: true)
                }
        }
    }
    
    final func clearCache(id: typeId? = nil, predicateEnum: LogicPredicateEnum? = nil){
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
    final func validate(_ dirtyData: [DecodableProtocol]) -> [PlainModelProtocol]? {
        guard dirtyData.count > 0
        else {
            log("validate(): datasource is empty", isErr: true)
            return nil
        }
    
        guard let implement = self as? ModelOwnerPresenterProtocol
            else {
                log("validate(): downcasting error", isErr: true)
                return nil
            }
        let required = "\(implement.modelClass)"
        let current = getRawClassName(object: type(of: dirtyData[0]))
        guard required == current
        else {
            log("validate(): returned datasource incorrected", isErr: true)
            return nil
        }
        return dirtyData as? [PlainModelProtocol]
    }
    
    
    func enrichData(validated: [PlainModelProtocol]) -> [PlainModelProtocol]? {
        // override if needed
        return validated
    }
    
    final func viewReloadData(){
        sort()
        view?.viewReloadData(moduleEnum: moduleEnum)
        waitIndicator(start: false)
    }
    
    final func sort() {
       dataSource = dataSource.sorted {
               $0.getSortBy() > $1.getSortBy()
       }
    }
    
    
    final func save(enriched: [PlainModelProtocol]) {
        RealmService.save(models: enriched, update: true)
    }
    
    
    final func waitIndicator(start: Bool) {
        if start {
            view?.startWaitIndicator(moduleEnum)
        } else {
            view?.stopWaitIndicator(moduleEnum)
        }
    }
    
    
    private func log(_ msg: String, isErr: Bool) {
      if isErr {
          catchError(msg: "PlainBasePresenter: \(self.clazz): " + msg)
      } else {
          console(msg: "PlainBasePresenter: \(self.clazz): " + msg, printEnum: .presenter)
      }
    }
}



