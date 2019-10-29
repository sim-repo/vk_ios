import Foundation

public class DetailFriendPresenter: SectionedBasePresenter{
    
    var friend: Friend!
    
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
    
    
    func getFirstName() -> String {
        return friend.firstName ?? ""
    }
    
    func getAva() -> String {
        guard let url = friend.avaURL50
        else {
            //TODO: log err
            return DefaultHelper.getAvaURL50()
        }
        return url
    }
}
