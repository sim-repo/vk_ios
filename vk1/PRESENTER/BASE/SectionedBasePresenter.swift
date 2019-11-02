import Foundation

public class SectionedBasePresenter: SectionedPresenterProtocol {

    weak var view: ViewInputProtocol?
    
    var sortedDataSource: [SectionedModelProtocol] = []
    
    private var sectionsOffset: [Int] = []
    
    private var groupingProperties: [String] = []
    
    private var sectionsTitle: [Alphabet] = []
    
    var filteredText: String?
    
    var numberOfSections: Int {
        return sectionsOffset.count > 0 ? sectionsOffset.count : 1
    }
    
    //MARK: initial
    
    // when view is not exists
    required init(){}

    // init presenter and view simultaneously
    required convenience init(vc: ViewInputProtocol, completion: (()->Void)?) {
        self.init()
        self.view = vc
    }
    
    final func setView(view: ViewInputProtocol, completion: (()->Void)?) {
        self.view = view
        UI_THREAD { [weak self] in
           self?.view?.refreshDataSource()
           completion?()
        }
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
    
    
    
    func dataSourceIsEmpty() -> Bool {
        return sortedDataSource.isEmpty
    }
    
    func clearDataSource() {
        sortedDataSource.removeAll()
    }
    
    func getDataSource() -> [SectionedModelProtocol] {
        return sortedDataSource
    }
    
    func setModel(ds: [DecodableProtocol], didLoadedFrom: LoadModelType) {
        validate(ds)
        self.sortedDataSource = sortModel(ds)
        switch didLoadedFrom {
            case .diskFirst:
                return // data stored already
            case .networkFirst:
                saveModel(ds: ds)
        }
    }

    // check if datasource is conformed to model expected
    func validate(_ ds: [DecodableProtocol]) {
        guard ds.count > 0
        else {
           catchError(msg: "SectionBasePresenter: validate(): datasource is empty "  + self.className())
           return
        }
        guard let childPresenter = self as? ModelOwnerProtocol else {
            return
        }
        let required = "\(childPresenter.modelClass)"
        let current = getRawClassName(object: type(of: ds[0]))
        guard required == current
        else {
            catchError(msg: "SectionBasePresenter: validate(): returned datasource incorrected")
            return
        }
    }
    

    func sortModel(_ ds: [DecodableProtocol]) -> [SectionedModelProtocol]{
        let sectioned = ds as! [SectionedModelProtocol]
        return sectioned.sorted(by: { $0.getGroupByField() < $1.getGroupByField() })
    }
    

    func saveModel(ds: [DecodableProtocol]) {
        // TODO: implement
        didSaveModel()
    }
    
    @objc func addModel(_ notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
            if let model = dict["model"] as? SectionedModelProtocol {
                sortedDataSource.append(model)
            }
        }
    }
    
    
    private func didSaveModel(){
        UI_THREAD { [weak self] in
            self?.view?.refreshDataSource()
        }
    }

    
    func refreshData()->( [SectionedModelProtocol], [String] ){
       var temp: [SectionedModelProtocol]
       let models =  getModel()
       
       if let filteredText  = filteredText {
           temp = models.filter({$0.getGroupByField().lowercased().contains(filteredText.lowercased())})
       } else {
           temp = models
       }
       
       var groupingProps: [String] = []
       for model in temp {
           groupingProps.append( model.getGroupByField() )
       }
       return (temp, groupingProps)
    }
    
    

    func getModel()->[SectionedModelProtocol] {
       return sortedDataSource
    }
    


    final func setup(_sortedDataSource: [SectionedModelProtocol], _groupingProperties: [String]){
       guard _sortedDataSource.count > 0 else {
           sectionsOffset = []
           sectionsTitle = []
           return
       }
       sortedDataSource = _sortedDataSource
       groupingProperties = _groupingProperties
       (sectionsTitle, sectionsOffset)  = Alphabet.getOffsets(with: groupingProperties)
    }


    final func refreshDataSource(with completion: (([String])->Void)? ) {
       (sortedDataSource,groupingProperties) = refreshData()
       setup(_sortedDataSource: sortedDataSource, _groupingProperties: groupingProperties)
       guard let completion = completion else {return}
       print("refreshDataSource \(sortedDataSource.count)")
       completion(groupingProperties)
    }


    final func getGroupingProperties() -> [String] {
       return groupingProperties
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


    final func sectionName(section: Int)->String {
       guard sectionsTitle.count > 0
           else {
               return "A"
          }
       let idx = sectionsTitle[section].rawValue
       return String(Alphabet.titles[idx])
    }


    final func getData(indexPath: IndexPath) -> SectionedModelProtocol? {
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


    final func getIndexPath(model: SectionedModelProtocol) -> IndexPath?{
       
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

    func filterData(_ searchText: String) {
       filteredText = !searchText.isEmpty ? searchText : nil
    }

    func className() -> String {
       return String(describing: SectionedBasePresenter.self)
    }
    
    
    //MARK: overriding functions
    
    func loadFromDisk(completion: (()->Void)? = nil){
        catchError(msg: "SectionBasePresenter: loadFromDisk: override error")
    }
    
    func loadFromNetwork(completion: (()->Void)? = nil){
        catchError(msg: "SectionBasePresenter: loadFromNetwork: override error")
    }
}
