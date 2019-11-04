import Foundation

// base class using for sectioned view controllers only: table view, collection view

public class SectionedBasePresenter {

    // view
    weak var view: PushSectionedViewProtocol?
    
    // data source properties
    var sortedDataSource: [SectionModelProtocol] = []
    
    private var sectionsOffset: [Int] = []
    
    private var groupByIds: [String] = []
    
    private var sectionsTitle: [Alphabet] = []
    
    var filteredText: String?
    
    var clazz: String {
        return String(describing: self)
    }
    
    
    //MARK: initial
    
    
    // when view is not exists
    required init(){}
    
    // init presenter and view simultaneously
    required convenience init?(vc: PushViewProtocol) {
        self.init()
        validateView(vc)
        self.view = vc as? PushSectionedViewProtocol
    }
    

    
    private func validateView(_ vc: PushViewProtocol){
        guard let _ = vc as? PushSectionedViewProtocol
        else {
            catchError(msg: "SectionedBasePresenter: init(vc:completion) - incorrect passed vc")
            return
        }
    }
    
    
    // MARK: incoming model flow
    // network -> synchronizer -> presenter:
    // setModel() -> validate() -> sort() -> save() -> didSave() -> try view update
    
    func appendDataSource(dirtyData: [DecodableProtocol], didLoadedFrom: ModelLoadedFromEnum) {
        
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
                save(sorted: sortedDataSource)
        }
    }
    
    
    
    private func validate(_ dirtyData: [DecodableProtocol]) -> [SectionModelProtocol]? {
        
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
    
    
    
    private func sort() {
        sortedDataSource = sortedDataSource.sorted(by: {
            $0.getSortBy() < $1.getSortBy()
        })
    }
    
    
    func save(sorted: [SectionModelProtocol]) {
        didSave()
    }
    
    
    private func didSave(){
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.view?.viewReloadData(groupByIds: self.groupByIds)
        }
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
}



//MARK: called from view
extension SectionedBasePresenter: PullSectionPresenterProtocol {
    
    final func numberOfSections() -> Int {
        return sectionsOffset.count > 0 ? sectionsOffset.count : 1
    }
    
    
    final func numberOfRowsInSection(section: Int) -> Int {
        guard sectionsOffset.count > 0
            else {
                return sortedDataSource.count
        }
        let offset = sectionsOffset[section]
        
        guard numberOfSections() > section + 1
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
    
    
    final func getGroupBy() -> [String] {
        return groupByIds
    }
    
    
    final func getData(indexPath: IndexPath? = nil) -> ModelProtocol? {
        guard let idxPath = indexPath
        else {
            catchError(msg: "SectionedBasePresenter: \(clazz): getData(indexPath:) argument is nil")
            return nil
        }
        guard sectionsOffset.count > 0
            else {
                return sortedDataSource[idxPath.row]
        }
        let offset = sectionsOffset[idxPath.section]
        
        guard sortedDataSource.count > offset + idxPath.row
            else {
                return nil
        }
        
        return sortedDataSource[offset + idxPath.row]
    }
    
    
    final func getIndexPath(model: ModelProtocol) -> IndexPath?{
        
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
    
    
    final func viewDidFilterInput(_ searchText: String) {
        filteredText = !searchText.isEmpty ? searchText : nil
        filterAndRegroupData()
        self.view?.viewReloadData(groupByIds: self.groupByIds)
    }
    
    func viewDidDisappear() {
    }
    
    @objc func viewDidSeguePrepare(segueId: String, indexPath: IndexPath) {
    }
}


//MARK: called from synchronizer
extension SectionedBasePresenter: SynchronizedPresenterProtocol {
   
    final func setView(vc: PushViewProtocol) {
        validateView(vc)
        self.view = vc as? PushSectionedViewProtocol
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.filterAndRegroupData()
            self.view?.viewReloadData(groupByIds: self.groupByIds)
        }
    }
    
    final func dataSourceIsEmpty() -> Bool {
        return sortedDataSource.isEmpty
    }
    
    final func getDataSource() -> [ModelProtocol] {
        return sortedDataSource
    }
    
    final func clearDataSource() {
        sortedDataSource.removeAll()
    }
    
    // when response has got from network
    final func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion? = nil) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            self?.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
            console(msg: "SectionedBasePresenter: \(self?.clazz): didSuccessNetworkResponse")
            completion?()
        }
        return outerCompletion
    }
    
    
    // when all responses have got from network
    final func didSuccessNetworkFinish() {
        console(msg: "SectionedBasePresenter: \(clazz): didSuccessNetworkFinish")
        self.sort()
    }
    
}
