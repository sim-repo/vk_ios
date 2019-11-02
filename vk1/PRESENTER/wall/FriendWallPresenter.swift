import Foundation
import Alamofire

public class FriendWallPresenter: PlainBasePresenter {
    var friend: Friend?
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
    
    
    //MARK: override func
    override func validate(_ ds: [DecodableProtocol]) {
        guard ds is [FriendWall]
        else {
            catchError(msg: "FriendWallPresenter: validate()")
            return
        }
    }
}
