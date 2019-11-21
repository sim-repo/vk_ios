import Foundation


public class PlainBasePresenter {

    var modelType: AnyClass?  {
        return nil
    }
    
    weak var view: PushPlainViewProtocol? {
        willSet(newValue) {
            didSetViewCompletion?(newValue)
        }
    }
    
    var dataSource: [PlainModelProtocol] = [] {
        willSet {
           // THREAD_SAFETY { // to avoid UnsafeMutablePointer.deinitialize fatal error
                self.dataSource = newValue
            //}
        }
    }
    
    lazy var child = self as! ModelOwnerPresenterProtocol
    var pageInProgess = false
    lazy var moduleEnum = ModuleEnum(presenter: self)
    
    var clazz: String {
        return String(describing: self)
    }

    //for subscribing by child presenters
    var didSetViewCompletion: ((PushPlainViewProtocol?)->Void)?
    
    var sectionChildPresenter: PullSectionPresenterProtocol?
    var plainChildPresenter: PullPlainPresenterProtocol?
    
    //MARK:- initial
    
    // when view is not exists
    required init() {}
    
    // init presenter and view simultaneously
    required convenience init?(vc: PushViewProtocol) {
        self.init()
        guard let _view = vc as? PushPlainViewProtocol
        else {
            catchError(msg: "PlainBasePresenter: init(vc:) - incorrect passed vc")
            return
        }
        self.view = _view
    }
    
    
    final func validateView(_ vc: PushViewProtocol){
        guard let _ = vc as? PushPlainViewProtocol
        else {
            catchError(msg: "PlainBasePresenter: validateView(vc:) - incorrect passed vc")
            return
        }
    }
    

// MARK:- incoming model flow
// network -> synchronizer -> presenter:
// appendDataSource() -> validate() -> enrichData() -> viewReloadData() -> save()

    
    final func appendDataSource(dirtyData: [DecodableProtocol], didLoadedFrom: ModelLoadedFromEnum) {
         
        guard let validatedData = validate(dirtyData)
            else {
                   catchError(msg: "PlainBasePresenter: \(clazz): setModel(): no valid data")
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
                    catchError(msg: "PlainBasePresenter: \(clazz): enriched data is empty ")
                }
        }
    }
    
    // check if datasource is conformed to model expected
    final func validate(_ dirtyData: [DecodableProtocol]) -> [PlainModelProtocol]? {
        guard dirtyData.count > 0
        else {
            catchError(msg: "PlainBasePresenter: \(clazz): validate(): datasource is empty ")
            return nil
        }
    
        let required = "\(child.modelClass)"
        let current = getRawClassName(object: type(of: dirtyData[0]))
        guard required == current
        else {
            catchError(msg: "PlainBasePresenter: validate(): \(clazz): returned datasource incorrected")
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
}



