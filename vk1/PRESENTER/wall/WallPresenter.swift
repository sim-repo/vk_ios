import Foundation

class WallPresenter: PlainPresenterProtocols {
    
    var modelClass: AnyClass  {
        return Wall.self
    }
    
    func sort(){
        if let walls = dataSource as? [Wall] {
            dataSource = walls.sorted {
                $0.getSortBy() > $1.getSortBy()
            }
        }
    }
}


