import Foundation

class WallPresenter: PlainPresenterProtocols {
    
    var modelClass: AnyClass  {
        return Wall.self
    }
}


extension WallPresenter: PaginationPresenterProtocol {
    
}
