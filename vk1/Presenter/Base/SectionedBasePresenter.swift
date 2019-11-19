import Foundation

// base class using for sectioned view controllers only: table view, collection view
public class SectionedBasePresenter {

    
    weak var view: PushSectionedViewProtocol?
    
    // data source properties
    var sortedDataSource: [SectionModelProtocol] = [] {
        willSet {
            //PRESENTER_UI_THREAD { // to avoid UnsafeMutablePointer.deinitialize fatal error
                self.sortedDataSource = newValue
           // }
        }
    }
    
    var sectionsOffset: [Int] = []
    
    var groupByIds: [String] = []
    
    var sectionsTitle: [Alphabet] = []
    
    var filteredText: String?
    
    var clazz: String {
        return String(describing: self)
    }
    
    var sectionChild: PullSectionPresenterProtocol?
    var plainChild: PullPlainPresenterProtocol?
    
    
    
    //MARK:- initial
    
    // when view is not exists
    required init(){}
    
    // init presenter and view simultaneously
    required convenience init?(vc: PushViewProtocol) {
        self.init()
        setView(vc: vc)
    }
    
    
    final func validateView(_ vc: PushViewProtocol){
        guard let _ = vc as? PushSectionedViewProtocol
        else {
            catchError(msg: "SectionedBasePresenter: init(vc:completion) - incorrect passed vc")
            return
        }
    }
    


// MARK:- incoming new data flow
// network -> synchronizer -> presenter:
// appendDataSource() -> validate() -> enrichData() -> sort() -> save() -> didSave() -> try view update

        
    final func appendDataSource(dirtyData: [DecodableProtocol], didLoadedFrom: ModelLoadedFromEnum) {
        
        guard let validatedData = validate(dirtyData)
            else {
                catchError(msg: "SectionBasePresenter: setModel(): no valid data")
                return
        }
        
        for model in validatedData {
            sortedDataSource.append(model)
        }
        
        switch didLoadedFrom {
          case .disk:
              return // data stored already
          case .network:
               if let enriched = enrichData(validated: sortedDataSource) {
                   save(enriched: enriched)
               } else {
                   catchError(msg: "PlainBasePresenter: \(clazz): enriched data is empty ")
               }
        }
    }
    
    
    
    final func validate(_ dirtyData: [DecodableProtocol]) -> [SectionModelProtocol]? {
        
        guard dirtyData.count > 0
            else {
                catchError(msg: "SectionBasePresenter: \(clazz): validate(): datasource is empty")
                return nil
        }
        
        guard let childPresenter = self as? ModelOwnerPresenterProtocol else {
            catchError(msg: "SectionBasePresenter: \(clazz): validate(): OwnModelProtocol is not implemented")
            return nil
        }
        
        // check class types
        let expectedClass = "\(childPresenter.modelClass)"
        let currentClass = getRawClassName(object: type(of: dirtyData[0]))
        guard expectedClass == currentClass
            else {
                catchError(msg: "SectionBasePresenter: \(clazz): validate(): returned datasource is incorrect")
                return nil
        }
        return dirtyData as? [SectionModelProtocol]
    }
    
    
    
    final func sort() {
        sortedDataSource = sortedDataSource.sorted(by: {
            $0.getSortBy() < $1.getSortBy()
        })
    }
    
    
    func enrichData(validated: [SectionModelProtocol]) -> [SectionModelProtocol]? {
           // override if needed
           return validated
    }
       
    final func viewReloadData(){
        self.view?.viewReloadData(groupByIds: self.groupByIds)
        let moduleEnum = ModuleEnum(presenter: self)
        self.view?.stopWaitIndicator(moduleEnum)
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
}


