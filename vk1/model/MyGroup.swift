import Foundation

class MyGroup {
    var text: String!
    
    init(text: String){
        self.text = text
    }
    
    public class func list()->[MyGroup] {
        return [
            MyGroup(text: "🌭"),
            MyGroup(text: "🏈"),
            MyGroup(text: "🎲"),
            MyGroup(text: "🚌"),
            MyGroup(text: "🏦"),
            MyGroup(text: "🏝"),
            MyGroup(text: "🛩")
        ]
    }
}
