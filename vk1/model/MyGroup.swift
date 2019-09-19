import Foundation

class MyGroup {
    var id: Int!
    var name: String!
    var icon: String!
    
    init(_ id: Int, name: String, _ icon: String){
        self.id = id;
        self.name = name
        self.icon = icon
    }
    
    convenience init (group: Group) {
        self.init(group.id, name: group.name, group.icon)
    }
    
    public class func list()->[MyGroup] {
        return [
            MyGroup(9, name: "food", "🌭"),
            MyGroup(10, name: "sport",  "🏈"),
            MyGroup(11, name: "gambling",  "🎲"),
            MyGroup(12, name: "transport",  "🚌"),
            MyGroup(13, name: "finance",  "🏦"),
            MyGroup(14, name: "travel",  "🏝"),
            MyGroup(15, name: "clothes",  "🧤")
        ]
    }
}
