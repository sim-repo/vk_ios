import Foundation


public class FriendWallPresenter: BasePresenter{
    
    var wall: [FriendWall]!
    
    var friend: Friend!
    
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
    
    override func initDataSource(){
        wall = FriendWall.list()
    }
    
    func numberOfRowsInSection() -> Int {
        return wall.count
    }
    
    func getImages(_ indexPath: IndexPath) -> [String]? {
        return wall?[indexPath.row].imageURLs
    }
    
    func getData(_ indexPath: IndexPath) -> FriendWall? {
        return wall?[indexPath.row]
    }
}
