import Foundation

class WallPresenter: PlainPresenterProtocols {
    
    
    var netFinishViewReload: Bool = false
    
    var modelClass: AnyClass  {
        return Wall.self
    }
}


extension WallPresenter: PaginationPresenterProtocol {
    
}
