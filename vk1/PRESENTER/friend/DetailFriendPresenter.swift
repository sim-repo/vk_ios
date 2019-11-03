import Foundation

class DetailFriendPresenter: SectionPresenterProtocols {
    
    var modelClass: AnyClass  {
        return DetailFriendPresenter.self
    }
    
    var friend: Friend!
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
}
