import Foundation

// base class using for sectioned view controllers only: table view, collection view

public class SectionedBasePresenter: PullSectionPresenterProtocol {

    // view
    weak var view: PushSectionedViewProtocol?
    
    // data source properties
    var sortedDataSource: [SectionModelProtocol] = []
    
    private var sectionsOffset: [Int] = []
    
    private var groupByIds: [String] = []
    
    private var sectionsTitle: [Alphabet] = []
    
    var filteredText: String?
    
    var numberOfSections: Int {
        return sectionsOffset.count > 0 ? sectionsOffset.count : 1
    }
    
    var clazz: String {
        return String(describing: SectionedBasePresenter.self)
    }
    
    
    //MARK: initial
    
    
    // when view is not exists
    required init(){}
    
    // init presenter and view simultaneously
    required convenience init(vc: PushViewProtocol, completion: (()->Void)?) {
        self.init()
        validateView(vc)
        self.view = vc as? PushSectionedViewProtocol
    }
    
    final func setView(vc: PushViewProtocol, completion: (()->Void)?) {
        validateView(vc)
        self.view = vc as? PushSectionedViewProtocol
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.filterAndRegroupData()
            self.view?.viewReloadData(groupByIds: self.groupByIds)
            completion?()
        }
    }
    
    private func validateView(_ vc: PushViewProtocol){
        guard let _ = vc as? PushSectionedViewProtocol
        else {
            catchError(msg: "SectionedBasePresenter: init(vc:completion) - incorrect passed vc")
            return
        }
    }
    
    
    
    // MARK: data source
    
    func dataSourceIsEmpty() -> Bool {
        return sortedDataSource.isEmpty
    }
    
    func clearDataSource() {
        sortedDataSource.removeAll()
    }
        
    
    //MARK: network events
    
    // when data loaded from network
    // called from synchronizer
    final func didLoadFromNetwork(completion: onSuccessSyncCompletion? = nil) -> onSuccessPresenterCompletion {
        let outerCompletion: onSuccessPresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            self?.setModel(dirtyData: arr, didLoadedFrom: .network)
            completion?()
        }
        return outerCompletion
    }
    
    
    
    
    // MARK: incoming model flow
    // network -> synchronizer -> presenter:
    // setModel() -> saveModel() -> didSaveModel() -> try view update
    
    private func setModel(dirtyData: [DecodableProtocol], didLoadedFrom: ModelLoadedFromEnum) {
        
        guard let clearData = validate(dirtyData)
            else {
                catchError(msg: "SectionBasePresenter: setModel(): no clear data")
                return
        }
        
        self.sortedDataSource = sortModel(clearData)
        switch didLoadedFrom {
        case .disk:
        return // data stored already
        case .network:
            saveModel(ds: clearData)
        }
    }
    
    
    
    private func validate(_ dirtyData: [DecodableProtocol]) -> [DecodableProtocol]? {
        
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
        return dirtyData
    }
    
    
    
    private func sortModel(_ ds: [DecodableProtocol]) -> [SectionModelProtocol]{
        let sectioned = ds as! [SectionModelProtocol]
        return sectioned.sorted(by: { $0.getGroupBy() < $1.getGroupBy() })
    }
    
    
    
    func saveModel(ds: [DecodableProtocol]) {
        // TODO: implement
        didSaveModel()
    }
    
    
    
    private func didSaveModel(){
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.view?.viewReloadData(groupByIds: self.groupByIds)
        }
    }
    
    
    // called from view
    func viewDidFilterInput(_ searchText: String) {
        filteredText = !searchText.isEmpty ? searchText : nil
        filterAndRegroupData()
        self.view?.viewReloadData(groupByIds: self.groupByIds)
    }
    
    
    // called when set new filter or viewDidLoad
    private func filterAndRegroupData() {
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
    
    final func getGroupBy() -> [String] {
        return groupByIds
    }
    
    
    final func numberOfRowsInSection(section: Int) -> Int {
        guard sectionsOffset.count > 0
            else {
                return sortedDataSource.count
        }
        let offset = sectionsOffset[section]
        
        guard numberOfSections > section + 1
            else {
                return sortedDataSource.count - offset
        }
        
        let next = sectionsOffset[section+1]
        return next - offset
    }
    
    
    final func sectionTitle(section: Int)->String {
        guard sectionsTitle.count > 0
            else {
                return "A"
        }
        let idx = sectionsTitle[section].rawValue
        return String(Alphabet.titles[idx])
    }
    
    
    final func getData(indexPath: IndexPath) -> SectionModelProtocol? {
        guard sectionsOffset.count > 0
            else {
                return sortedDataSource[indexPath.row]
        }
        let offset = sectionsOffset[indexPath.section]
        
        guard sortedDataSource.count > offset + indexPath.row
            else {
                return nil
        }
        
        return sortedDataSource[offset + indexPath.row]
    }
    
    
    final func getIndexPath(model: SectionModelProtocol) -> IndexPath?{
        
        guard let sortedIdx = sortedDataSource.firstIndex(where: { $0.getId() == model.getId() })
            else {return nil}
        
        if sectionsOffset.count == 0 {
            return IndexPath(row: sortedIdx, section: 0)
        }
        
        guard let sectionIdx = sectionsOffset.firstIndex(where: { $0 > sortedIdx })
            else {return nil}
        guard sectionIdx > 0
            else {return nil}
        
        let offset = sectionsOffset[sectionIdx-1]
        
        let row = sortedIdx - offset
        
        return IndexPath(row: row, section: sectionIdx-1)
    }
    
    
    final func getCode(indexPath: IndexPath) -> String {
        return ""
    }
    

    

}


extension SectionedBasePresenter: SynchronizedPresenterProtocol {
   
    func getDataSource() -> [ModelProtocol] {
        return sortedDataSource
    }
}
