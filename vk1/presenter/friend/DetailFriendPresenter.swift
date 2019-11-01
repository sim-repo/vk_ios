import Foundation

public class DetailFriendPresenter: SectionedBasePresenter {
    
    var friend: Friend!
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
    
    //MARK: override func
    override func validate(_ ds: [DecodableProtocol]) {
        guard ds is [Friend]
        else {
            catchError(msg: "DetailFriendPresenter: validate()")
            return
        }
    }
}
