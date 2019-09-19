import Foundation

public class DetailFriendPresenter: BasePresenter{
    
    var friend: Friend!
    
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
    
    
    func getName() -> String {
        return friend.name
    }
    
    func getAva() -> String {
        return friend.ava
    }
    
}
