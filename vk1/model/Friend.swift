import Foundation

class Friend {
    var name: String!
    
    init(text: String){
        self.name = text
    }
    
    public class func list()->[Friend] {
        return [
            Friend(text: "Саша"),
            Friend(text: "Маша"),
            Friend(text: "Даша"),
            Friend(text: "Юра"),
            Friend(text: "Катя"),
            Friend(text: "Леша"),
            Friend(text: "Женя")
        ]
    }
}
