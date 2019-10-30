import Foundation

protocol SectionedPresenterProtocol: PresenterProtocol {
    
    var view: ViewInputProtocol? {get set}
    var numberOfSections: Int {get}
    func numberOfRowsInSection (section: Int)->Int
    func filterData(_ filterText: String)
    func getGroupingProperties() -> [String]
    func refreshDataSource(with completion: (([String])->Void)? )
    func getData(indexPath: IndexPath) -> SectionedModelProtocol?
    func sectionName(section: Int)->String
    func getDataSource() -> [SectionedModelProtocol]
}
