import Foundation
import Alamofire

class FriendWallPresenter: PlainPresenterProtocols {

    var modelClass: AnyClass  {
        return Wall.self
    }
    
    var friend: Friend?
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
    
    func getFriend() -> Friend? {
        return friend
    }
}
