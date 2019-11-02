import Foundation


public class PlainBasePresenter: PlainPresenterProtocol {

    var modelType: AnyClass?  {
        return nil
    }
    
    var numberOfSections: Int = 1
    
    var numberOfRowsInSection: Int {
        return dataSource.count 
    }
    
    weak var view: PlainViewInputProtocol?
    var dataSource: [PlainModelProtocol] = []
    

    //MARK: initial
    
    // when view is not exists
    required init() {}
    
    // init presenter and view simultaneously
    required convenience init(vc: ViewInputProtocol, completion: (()->Void)?) {
        self.init()
        guard let _view = vc as? PlainViewInputProtocol
        else {
            catchError(msg: "PlainBasePresenter: init(vc:completion) - incorrect passed vc")
            return
        }
        self.view = _view
    }
    
    
    //MARK: network events
    
    // when data loaded from network
    final func didLoadFromNetwork(completion: onSuccessSyncCompletion? = nil) -> onSuccessPresenterCompletion {
        let outerCompletion: onSuccessPresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            self?.setModel(ds: arr, didLoadedFrom: .network)
            completion?()
        }
        return outerCompletion
    }
    
    func setView(vc: ViewInputProtocol, completion: (()->Void)?) {
        validateView(vc)
        self.view = vc as? PlainViewInputProtocol
        guard dataSource.count > 0
            else { return }
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.view?.viewReloadData()
            completion?()
        }
    }
    
    
    private func validateView(_ vc: ViewInputProtocol){
        guard let _ = vc as? SectionedViewInputProtocol
        else {
            catchError(msg: "SectionedBasePresenter: init(vc:completion) - incorrect passed vc")
            return
        }
    }
    
    
    func dataSourceIsEmpty() -> Bool {
        return dataSource.isEmpty
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
    
    func setModel(ds: [DecodableProtocol], didLoadedFrom: ModelLoadedFromEnum) {
        guard ds.count > 0
        else {
            catchError(msg: "PlainBasePresenter: setModel: datasource is empty: " + self.className())
             return
        }
        
        validate(ds)
        switch didLoadedFrom {
           case .disk:
               return // data stored already
           case .network:
                let models = ds as! [PlainModelProtocol]
                for model in models {
                    dataSource.append(model)
                }
                saveModel(ds: ds)
        }
    }
    
    // check if datasource is conformed to model expected
    private func validate(_ ds: [DecodableProtocol]) {
        guard ds.count > 0
        else {
           catchError(msg: "PlainBasePresenter: validate(): datasource is empty "  + self.className())
           return
        }
        guard let childPresenter = self as? OwnModelProtocol else {
            return
        }
        let required = "\(childPresenter.modelClass)"
        let current = getRawClassName(object: type(of: ds[0]))
        guard required == current
        else {
            catchError(msg: "PlainBasePresenter: validate(): returned datasource incorrected")
            return
        }
    }
    
    func saveModel(ds: [DecodableProtocol]) {
        didSaveModel()
    }
    
    func didSaveModel(){
        UI_THREAD { [weak self] in
            self?.view?.viewReloadData()
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
    
}

