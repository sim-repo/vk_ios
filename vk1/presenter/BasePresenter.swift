import Foundation

public class BasePresenter {
    
    private var sortedDataSource: [AnyObject] = []
    private var sectionsOffset: [Int] = []
    private var groupingProperties: [String] = []
    private var sectionsTitle: [Alphabet] = []
    var filteredText: String?
    
    var numberOfSections: Int {
        return sectionsOffset.count
    }
    
    func initDataSource(){}
    
    init(){
        initDataSource()
    }
    
    func refreshData()->( [AnyObject], [String] ){
        return ([],[])
    }
    
    
    final func setup(_sortedDataSource: [AnyObject], _groupingProperties: [String]){
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
        
        completion(groupingProperties)
    }
    
    
    final func getGroupingProperties() -> [String] {
        return groupingProperties
    }
    
    
    final func numberOfRowsInSection(section: Int) -> Int {
        let offset = sectionsOffset[section]
        
        guard numberOfSections > section + 1
            else {
                return sortedDataSource.count - offset
        }
        
        let next = sectionsOffset[section+1]
        return next - offset
    }
    
    
    final func sectionName(section: Int)->String {
        let idx = sectionsTitle[section].rawValue
        return String(Alphabet.titles[idx])
    }
    
    final func getData(indexPath: IndexPath) -> AnyObject? {
        let offset = sectionsOffset[indexPath.section]
        
        guard sortedDataSource.count > offset + indexPath.row
            else {
                return nil
        }
        
        return sortedDataSource[offset + indexPath.row]
    }
    
    final func getCode(indexPath: IndexPath) -> String {
        return ""
    }
    
    func filterData(_ searchText: String) {
        filteredText = !searchText.isEmpty ? searchText : nil
    }
}
