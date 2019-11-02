import Foundation

protocol SectionedPresenterProtocol: PresenterProtocol {
    
    var view: SectionedViewInputProtocol? {get set}
    var numberOfSections: Int {get}
    
    func numberOfRowsInSection (section: Int)->Int
    func getGroupBy() -> [String]
    func getData(indexPath: IndexPath) -> SectionedModelProtocol?
    func sectionName(section: Int)->String
    func getDataSource() -> [SectionedModelProtocol]
    
    
    func viewDidFilterInput(_ filterText: String)
}
