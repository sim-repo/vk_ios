import Foundation
import Alamofire

public class FriendWallPresenter: PlainBasePresenter {
    var friend: Friend?
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
}
