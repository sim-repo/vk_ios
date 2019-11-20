import Foundation

class NewsPresenter: PlainPresenterProtocols {
    
    var modelClass: AnyClass  {
        return News.self
    }
}


extension NewsPresenter: PaginationPresenterProtocol {
    
}
