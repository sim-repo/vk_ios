import Foundation


public class SectionedBasePresenter : BasePresenter {
    
    var sectionsOffset: [Int] = []
    
    var groupByIds: [String] = []
    
    var sectionsTitle: [Alphabet] = []
    
    var filteredText: String?
    
    
    override func viewReloadData(){
        if let sortable = self as? SortablePresenterProtocol {
            sortable.sort()
        }
        getView()?.viewReloadData(groupByIds: self.groupByIds)
        waitIndicator(start: false)
    }
    
    
    func getView() -> PresentableSectionedViewProtocol? {
       guard let view = view as? PresentableSectionedViewProtocol
       else {
           log("viewReloadData() \(String(describing: self.view)) doesn't conform protocol PresentableSectionedViewProtocol", level: .error)
           return nil
       }
        return view
    }
    
    
    final func filterAndRegroupData() {
        
        var filteredDataSource: [ModelProtocol]
        let groupable = (self as! GroupablePresenterProtocol)
        
        if let filteredText  = filteredText {
            filteredDataSource = dataSource.filter({groupable.groupBy(model: $0).lowercased().contains(filteredText.lowercased())})
        } else {
            filteredDataSource = dataSource
        }
        
        guard filteredDataSource.isEmpty == false
            else {
                sectionsOffset = []
                sectionsTitle = []
                return
        }
        
        var groupBy: [String] = []
        
        filteredDataSource.forEach{
            groupBy.append(groupable.groupBy(model: $0))
        }
        
        dataSource = filteredDataSource
        groupByIds = groupBy
        (sectionsTitle, sectionsOffset)  = Alphabet.getOffsets(with: groupByIds)
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "SectionBasePresenter: \(self.clazz): ", msg, level: level, printEnum: .presenter)
    }
}


