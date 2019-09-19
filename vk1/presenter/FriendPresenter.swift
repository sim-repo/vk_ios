import Foundation

public class FriendPresenter: BasePresenter{
    
    var friends: [Friend]!
    
    override func initDataSource(){
        friends = Friend.list()
    }
    
    func numberOfRowsInSection() -> Int {
        return friends.count
    }
    
    func getName(_ indexPath: IndexPath) -> String {
        return friends?[indexPath.row].name ?? ""
    }
    
    func getAva(_ indexPath: IndexPath) -> String {
        return friends?[indexPath.row].ava ?? ""
    }
    
    func getFriend(_ indexPath: IndexPath?) -> Friend? {
        guard let idxPath = indexPath
            else {return nil}
        return friends[idxPath.row]
    }
}
