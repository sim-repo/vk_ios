import Foundation

class Group {
    var id: Int!
    var name: String!
    var icon: String!
    
    init(_ id: Int, name: String, _ icon: String){
        self.id = id;
        self.name = name
        self.icon = icon
    }
    
    public class func list()->[Group] {
        return [
            Group(1, name: "glasses", "👓"),
            Group(2, name: "fish", "🦈"),
            Group(3, name: "flowers", "🌿"),
            Group(4, name: "fruits", "🍎"),
            Group(5, name: "pizza", "🍕"),
            Group(6, name: "music", "🎷"),
            Group(7, name: "cosmos", "🛰")
        ]
    }
}
