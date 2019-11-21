import Foundation

class FriendPresenter: SectionPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    
    var modelClass: AnyClass  {
        return Friend.self
    }
}
