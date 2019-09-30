import Foundation

public class FriendPresenter: BasePresenter{
    
    var friends: [Friend]!
    
    override func initDataSource(){
        friends = Friend.list()
        var groupingProps: [String] = []
        for friend in friends {
            groupingProps.append(friend.name)
        }
        setup(_sortedDataSource: friends, _groupingProperties: groupingProps)
    }
    
    override func refreshData()->( [AnyObject], [String] ){
        var friends: [Friend]
        
        if let filteredText  = filteredText {
            friends = Friend.list().filter({$0.name.lowercased().contains(filteredText.lowercased())})
        } else {
            friends = Friend.list()
        }
        
        var groupingProps: [String] = []
        for friend in friends {
            groupingProps.append(friend.name )
        }
        return (friends, groupingProps)
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
