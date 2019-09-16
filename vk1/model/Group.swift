import Foundation

class Group {
    var text: String!
    
    init(text: String){
        self.text = text
    }
    
    public class func list()->[Group] {
        return [
            Group(text: "🗾"),
            Group(text: "🎑"),
            Group(text: "🌌"),
            Group(text: "🌁"),
            Group(text: "🌃"),
            Group(text: "🌇"),
            Group(text: "🎆")
        ]
    }
}
