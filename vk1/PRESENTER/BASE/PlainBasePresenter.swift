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
    
    var dataSource: [PlainModelProtocol] = []
    
    
    var clazz: String {
        return String(describing: self)
    }

    //for subscribing by child presenters
    var didSetViewCompletion: ((PushPlainViewProtocol?)->Void)?
    
    var sectionChildPresenter: PullSectionPresenterProtocol?
    var plainChildPresenter: PullPlainPresenterProtocol?
    
    
    //MARK: initial
    
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
    
    
    private func validateView(_ vc: PushViewProtocol){
        guard let _ = vc as? PushPlainViewProtocol
        else {
            catchError(msg: "PlainBasePresenter: validateView(vc:) - incorrect passed vc")
            return
        }
    }


    
    // MARK: incoming model flow
    // network -> synchronizer -> presenter:
    // setModel() -> validate() -> save() -> didSave() -> try view update

    private func appendDataSource(dirtyData: [DecodableProtocol], didLoadedFrom: ModelLoadedFromEnum) {
         
        guard let validatedData = validate(dirtyData)
            else {
                   catchError(msg: "PlainBasePresenter: \(clazz): setModel(): no valid data")
                   return
           }
    
        switch didLoadedFrom {
           case .disk:
               return // data stored already
           case .network:
                for model in validatedData {
                    dataSource.append(model)
                }
                save(validated: validatedData)
        }
    }
    
    // check if datasource is conformed to model expected
    private func validate(_ dirtyData: [DecodableProtocol]) -> [PlainModelProtocol]? {
        guard dirtyData.count > 0
        else {
            catchError(msg: "PlainBasePresenter: \(clazz): validate(): datasource is empty ")
            return nil
        }
        guard let childPresenter = self as? ModelOwnerPresenterProtocol
        else {
            catchError(msg: "PlainBasePresenter: \(clazz): validate(): OwnModelProtocol is not implemented")
            return nil
        }
        let required = "\(childPresenter.modelClass)"
        let current = getRawClassName(object: type(of: dirtyData[0]))
        guard required == current
        else {
            catchError(msg: "PlainBasePresenter: validate(): \(clazz): returned datasource incorrected")
            return nil
        }
        return dirtyData as? [PlainModelProtocol]
    }
    
    
    func save(validated: [PlainModelProtocol]) {
        didSave()
    }
    
    func didSave() {
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            let moduleEnum = ModuleEnum(presenter: self)
            self.view?.viewReloadData(moduleEnum: moduleEnum)
        }
    }
    
    
    func sort() {
       dataSource = dataSource.sorted {
               $0.getSortBy() > $1.getSortBy()
        }
    }
    
    final func getData(indexPath: IndexPath? = nil) -> ModelProtocol? {
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
    
    
    final func getIndexPath(model: ModelProtocol) -> IndexPath?{
        guard let idx = dataSource.firstIndex(where: { $0.getId() == model.getId() })
            else {return nil}
        
        return IndexPath(row: idx, section: 0)
    }
}




//MARK: called from view
extension PlainBasePresenter: PullPlainPresenterProtocol {
    
    final func numberOfRowsInSection() -> Int {
        return dataSource.count
    }
    
    @objc func viewDidDisappear() {
        SynchronizerManager.shared.viewDidDisappear(presenter: self)
    }
    
    func viewDidFilterInput(_ filterText: String) {
    }
    
    func getSectionChild() -> PullSectionPresenterProtocol? {
        return sectionChildPresenter
    }
    
    func getPlainChild() -> PullPlainPresenterProtocol? {
        return plainChildPresenter
    }
    
    func viewDidSeguePrepare(segueId: SegueIdEnum, indexPath: IndexPath) {
      
        guard let model = getData(indexPath: indexPath)
                    else {
                        catchError(msg: "PlainBasePresenter: \(clazz): viewDidSeguePrepare(): no data with indexPath: \(indexPath)")
                        return
                    }
        
        guard let detailPresenter = PresenterFactory.shared.getInstance(segueId: segueId) as? DetailPresenterProtocol
            else {
                catchError(msg: "PlainBasePresenter: \(clazz): viewDidSeguePrepare(): can't get detailPresenter by segueId: \(segueId.rawValue) ")
                return
            }
        detailPresenter.setDetailModel(model: model)
    }
}



//MARK: called from synchronizer & presenter factory
extension PlainBasePresenter: SynchronizedPresenterProtocol {
    
    final func getDataSource() -> [ModelProtocol] {
        return dataSource
    }
    
    final func dataSourceIsEmpty() -> Bool {
        return dataSource.isEmpty
    }
    
    final func clearDataSource() {
        dataSource.removeAll()
    }
    
    final func setView(vc: PushViewProtocol) {
        validateView(vc)
        self.view = vc as? PushPlainViewProtocol
        guard dataSource.count > 0
            else { return }
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            let moduleEnum = ModuleEnum(presenter: self)
            self.view?.viewReloadData(moduleEnum: moduleEnum)
        }
    }
    
    // when response has got from network
    final func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion? = nil) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            self?.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
            console(msg: "PlainBasePresenter: \(self?.clazz): didSuccessNetworkResponse")
            completion?()
        }
        return outerCompletion
    }
    
    // when all responses have got from network
    final func didSuccessNetworkFinish() {
        console(msg: "PlainBasePresenter: \(clazz): didSuccessNetworkFinish")
        self.sort()
    }
}
