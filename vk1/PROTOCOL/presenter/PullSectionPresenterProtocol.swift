import Foundation

// view get access to presenter
protocol PullSectionPresenterProtocol: PullPresenterProtocol {
        
    var numberOfSections: Int { get }
    func numberOfRowsInSection (section: Int) -> Int
    func sectionTitle(section: Int)->String
    
    
    // alphabet searching
    func getGroupBy() -> [String]
    
    func getData(indexPath: IndexPath) -> SectionModelProtocol?
    
    
    func viewDidFilterInput(_ filterText: String)
}


