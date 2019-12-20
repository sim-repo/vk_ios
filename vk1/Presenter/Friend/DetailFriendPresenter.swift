import Foundation

class DetailFriendPresenter: SectionPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    var modelClass: AnyClass  {
        return DetailFriendPresenter.self
    }
    
    var friend: Friend!
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
}
