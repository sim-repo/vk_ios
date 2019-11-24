import Foundation

// base class using for sectioned view controllers only: table view, collection view
public class SectionedBasePresenter {

    
    var modelType: AnyClass?  {
        return nil
    }
    
    lazy var moduleEnum = ModuleEnum(presenter: self)
    
    weak var view: PushSectionedViewProtocol? {
       willSet(newValue) {
           didSetViewCompletion?(newValue)
       }
    }
    
    var sortedDataSource: [SectionModelProtocol] = []
    
    var sectionsOffset: [Int] = []
    
    var groupByIds: [String] = []
    
    var sectionsTitle: [Alphabet] = []
    
    var filteredText: String?
    
    var clazz: String {
        return String(describing: self)
    }
    
    var didSetViewCompletion: ((PushSectionedViewProtocol?)->Void)?
    
    var pageInProgess = false
    
    //MARK:- complex
    var subSectionPresenter: PullSectionPresenterProtocol?
    var subPlainPresenter: PullPlainPresenterProtocol?
    
    
    
    //MARK:- initial
    
    // when view is not exists
    required init(){}
    
    // init presenter and view simultaneously
    required convenience init?(vc: PushViewProtocol) {
        self.init()
        guard let _view = vc as? PushSectionedViewProtocol
        else {
            log("init(vc:) - incorrect passed vc", isErr: true)
            return
        }
        self.view = _view
    }
    
    
    final func validateView(_ vc: PushViewProtocol){
        guard let _ = vc as? PushSectionedViewProtocol
        else {
            log("init(vc:) - incorrect passed vc", isErr: true)
            return
        }
    }
    


// MARK:- incoming new data flow
// network -> synchronizer -> presenter:
// appendDataSource() -> validate() -> enrichData() -> sort() -> save() -> didSave() -> try view update

        
    final func appendDataSource(dirtyData: [DecodableProtocol], didLoadedFrom: ModelLoadedFromEnum) {
        
        guard let validatedData = validate(dirtyData)
            else {
                log("setModel(): no valid data", isErr: true)
                return
        }
        
        for model in validatedData {
            if !sortedDataSource.contains(where: {$0.getId() == model.getId()}){
                sortedDataSource.append(model)
            }
        }
        
        switch didLoadedFrom {
          case .disk:
              return // data stored already
          case .network:
               if let enriched = enrichData(validated: sortedDataSource) {
                   save(enriched: enriched)
               } else {
                   log("enriched data is empty", isErr: true)
               }
        }
    }
    
    final func clearCache(id: typeId?, predicateEnum: LogicPredicateEnum?){
        if let id_ = id, let predicate = predicateEnum {
            switch predicate {
                case .equal:
                    sortedDataSource.removeAll(where: {$0.getId() == id_})
                case .notEqual:
                    sortedDataSource.removeAll(where: {$0.getId() != id_})
            }
        } else {
             sortedDataSource.removeAll()
        }
    }
    
    final func validate(_ dirtyData: [DecodableProtocol]) -> [SectionModelProtocol]? {
        
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
        
        // check class types
        let required = "\(implement.modelClass)"
        let current = getRawClassName(object: type(of: dirtyData[0]))
        guard required == current
               else {
                   log("validate(): returned datasource incorrected", isErr: true)
                   return nil
               }
        return dirtyData as? [SectionModelProtocol]
    }
    
    func enrichData(validated: [SectionModelProtocol]) -> [SectionModelProtocol]? {
            // override if needed
            return validated
     }
    
    final func viewReloadData(){
        sort()
        view?.viewReloadData(groupByIds: self.groupByIds)
        waitIndicator(start: false)
    }
    
    final func sort() {
        sortedDataSource = sortedDataSource.sorted(by: {
            $0.getSortBy() < $1.getSortBy()
        })
    }
    
    final func save(enriched: [SectionModelProtocol]) {
       RealmService.save(models: enriched, update: true)
    }
    
    
    
    final func filterAndRegroupData() {
        
        var filteredDataSource: [SectionModelProtocol]

        if let filteredText  = filteredText {
            filteredDataSource = sortedDataSource.filter({$0.getGroupBy().lowercased().contains(filteredText.lowercased())})
        } else {
            filteredDataSource = sortedDataSource
        }
        
        guard filteredDataSource.isEmpty == false
            else {
                sectionsOffset = []
                sectionsTitle = []
                return
        }
        
        var groupBy: [String] = []
        
        filteredDataSource.forEach{
            groupBy.append($0.getGroupBy())
        }
        
        sortedDataSource = filteredDataSource
        groupByIds = groupBy
        (sectionsTitle, sectionsOffset)  = Alphabet.getOffsets(with: groupByIds)
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
          catchError(msg: "SectionBasePresenter: \(self.clazz): " + msg)
      } else {
          console(msg: "SectionBasePresenter: \(self.clazz): " + msg, printEnum: .presenter)
      }
    }
}


