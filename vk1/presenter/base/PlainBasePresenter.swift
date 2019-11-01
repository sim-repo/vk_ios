import Foundation


public class PlainBasePresenter: PlainPresenterProtocol {

    var modelType: AnyClass?  {
        return nil
    }
    
    var numberOfSections: Int = 1
    
    var numberOfRowsInSection: Int {
        return dataSource.count 
    }
    
    weak var view: ViewInputProtocol?
    var dataSource: [PlainModelProtocol] = []
    

    //MARK: initial
    
    // when view is not exists
    required init() {}
    
    // init presenter and view simultaneously
    required convenience init(vc: ViewInputProtocol, completion: (()->Void)?) {
        self.init()
        self.view = vc
    }
    
    
    //MARK: network events
    
    // when data loaded from network
    final func didLoadFromNetwork(completion: onSuccessSyncCompletion? = nil) -> onSuccessPresenterCompletion {
        let outerCompletion: onSuccessPresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            self?.setModel(ds: arr, didLoadedFrom: .networkFirst)
            completion?()
        }
        return outerCompletion
    }
    
    func setView(view: ViewInputProtocol, completion: (()->Void)?) {
        self.view = view
        guard dataSource.count > 0
            else { return }
        UI_THREAD { [weak self] in
            self?.view?.refreshDataSource()
            completion?()
        }
    }
    
    
    func className() -> String {
        return String(describing: self)
    }

    func getDataSource() -> [PlainModelProtocol] {
        return dataSource
    }
    
    func clearDataSource() {
        dataSource.removeAll()
    }

    func viewDidDisappear() {
    }
    
    func setModel(ds: [DecodableProtocol], didLoadedFrom: LoadModelType) {
        guard ds.count > 0
        else {
            catchError(msg: "PlainBasePresenter: setModel: datasource is empty: " + self.className())
             return
        }
        
        validate(ds)
        switch didLoadedFrom {
           case .diskFirst:
               return // data stored already
           case .networkFirst:
                let models = ds as! [PlainModelProtocol]
                for model in models {
                    dataSource.append(model)
                }
                saveModel(ds: ds)
        }
    }
    
    // check if datasource is conformed to model expected
    func validate(_ ds: [DecodableProtocol]) {
        catchError(msg: "SectionBasePresenter: validate: override error")
    }

    func saveModel(ds: [DecodableProtocol]) {
        // TODO: implement
        didSaveModel()
    }
    
    func didSaveModel(){
        UI_THREAD { [weak self] in
            self?.view?.refreshDataSource()
        }
    }
    
    final func getData(_ indexPath: IndexPath? = nil) -> PlainModelProtocol? {
        // for non-list DS
        if indexPath == nil {
            guard dataSource.count == 1
                else {
                    catchError(msg: "PlainBasePresenter: getData(): datasource must be 1")
                    return nil
                }
            return dataSource[0]
        }
        
        // else for list DS
        guard let idx = indexPath
            else { return nil }
        guard dataSource.count > idx.row
            else {
                return nil
        }
        return dataSource[idx.row]
    }
    
    
    final func getIndexPath(model: PlainModelProtocol) -> IndexPath?{
        guard let idx = dataSource.firstIndex(where: { $0.getId() == model.getId() })
            else {return nil}
        
        return IndexPath(row: idx, section: 0)
    }
    
    
    //MARK: overriding functions
    
    func loadFromNetwork(completion: (()->Void)? = nil){
        catchError(msg: "PlainBasePresenter: loadFromNetwork: override error")
    }
    
    func loadFromDisk(completion: (()->Void)? = nil){
        catchError(msg: "PlainBasePresenter: loadFromDisk: override error")
    }
}

