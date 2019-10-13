import Foundation

class Friend {
    var id: Int!
    var name: String!
    var ava: String!
    
    init(id: Int){
        self.id = id
        var index = Int(arc4random_uniform(UInt32(DataGeneratorHelper.names.count)))
        self.name = DataGeneratorHelper.names[index]
      
        index = Int(arc4random_uniform(UInt32(DataGeneratorHelper.pictures.count)))
        self.ava = DataGeneratorHelper.pictures[index]
    }
    
    public class func list()->[Friend] {
        var friends: [Friend] = []
        for i in 0...100 {
            let friend = Friend(id: i)
            friends.append(friend)
        }
        
        return friends.sorted(by: { $0.name < $1.name })
    }
}
