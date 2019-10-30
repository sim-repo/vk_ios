import Foundation


public class PlainBasePresenter: PlainPresenterProtocol {

    var numberOfSections: Int = 1
    
    var numberOfRowsInSection: Int {
        return dataSource.count 
    }
    
    weak var view: ViewInputProtocol?
    var dataSource: [PlainModelProtocol] = []
    

    //MARK: constuctor
    required init() {}
    
    // view is not exists
    required convenience init(vc: ViewInputProtocol, completion: (()->Void)?) {
        self.init()
        self.view = vc
    }
    
    func setView(view: ViewInputProtocol, completion: (()->Void)?) {
        self.view = view
        UI_THREAD { [weak self] in
            self?.view?.refreshDataSource()
            completion?()
        }
    }
    
    
    func className() -> String {
        return String(describing: PlainPresenterProtocol.self)
    }

    func getDataSource() -> [PlainModelProtocol] {
        return dataSource
    }
    
    func clearDataSource() {
        dataSource.removeAll()
    }

    
    func setModel(ds: [DecodableProtocol], didLoadedFrom: LoadModelType) {
        guard ds.count > 0
        else {
             catchError(msg: "PlainBasePresenter: setModel: datasource is empty")
             return
        }
        
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

    func saveModel(ds: [DecodableProtocol]) {
        // TODO: implement
        didSaveModel()
    }
    
    private func didSaveModel(){
        UI_THREAD { [weak self] in
            self?.view?.refreshDataSource()
        }
    }
    
    final func getData(_ indexPath: IndexPath) -> PlainModelProtocol? {
        guard dataSource.count > indexPath.row
            else {
                return nil
        }
        return dataSource[indexPath.row]
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

