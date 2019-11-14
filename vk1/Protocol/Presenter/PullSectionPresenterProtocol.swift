import Foundation

// view get access to presenter
protocol PullSectionPresenterProtocol: PullPresenterProtocol {
        
    func numberOfSections() -> Int
    func numberOfRowsInSection (section: Int) -> Int
    func sectionTitle(section: Int)->String
    
    
    // alphabet searching
    func getGroupBy() -> [String]
}


