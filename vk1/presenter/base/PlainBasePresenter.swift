import Foundation


public class PlainBasePresenter: PlainPresenterProtocol {

    
    var numberOfSections: Int = 1
    
    var numberOfRowsInSection: Int {
        return dataSource.count 
    }
    
    weak var view: ViewProtocolDelegate?
    var dataSource: [PlainModelProtocol] = []
    

    //MARK: constuctor
    
    // init from view
    required convenience init(beginLoadFrom: LoadModelType, completion: (()->Void)?) {
        self.init()
        loadModel(beginLoadFrom, completion)
    }
    
    // view is not exists
    required convenience init(vc: ViewProtocolDelegate, beginLoadFrom: LoadModelType, completion: (()->Void)?) {
        self.init()
        self.view = vc
        loadModel(beginLoadFrom, completion)
    }
    
    
    func setView(view: ViewProtocolDelegate, completion: (()->Void)?) {
        self.view = view
        completion?()
    }
    
    
    func className() -> String {
        return String(describing: PlainPresenterProtocol.self)
    }


    
    private final func loadModel(_ loadType: LoadModelType, _ completion: (()->Void)?) {
        switch loadType {
        case .diskFirst:
            print("######## LOADING FROM DISK ########")
            let outerCompletion = {[weak self] in
                if self?.dataSource.count == 0 {
                    print("######## TRYING LOADING FROM NETWORK ########")
                    self?.loadFromNetwork(completion: completion)
                } else {
                    completion?()
                }
            }
            loadFromDisk(completion: outerCompletion)
        case .networkFirst:
            print("######## LOADING FROM NETWORK ########")
            let outerCompletion = {[weak self] in
                if self?.dataSource.count == 0 {
                    print("######## TRYING LOADING FROM DISK ########")
                    self?.loadFromDisk(completion: completion)
                } else {
                    completion?()
                }
            }
            loadFromNetwork(completion: outerCompletion)
        }
    }

    
    func setModel(ds: [DecodableProtocol], didLoadedFrom: LoadModelType) {
        guard ds.count > 0
        else {
            catchError()
            return
        }
        
       switch didLoadedFrom {
           case .diskFirst:
               return // data stored already
           case .networkFirst:
                dataSource = ds as! [PlainModelProtocol]
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
        fatalError("Override Error: this method must be overrided by child classes")
    }
    
    func loadFromDisk(completion: (()->Void)? = nil){
        fatalError("Override Error: this method must be overrided by child classes")
    }
}

