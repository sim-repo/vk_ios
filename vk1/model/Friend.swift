import Foundation

class Friend {
    var name: String!
    var ava: String!
    
    init(_ name: String, _ ava: String){
        self.name = name
        self.ava = ava;
    }
    
    public class func list()->[Friend] {
        return [
            Friend("Саша", "👨‍🦰"),
            Friend("Маша", "👩‍🦳"),
            Friend("Даша", "👱‍♀️"),
            Friend("Юра", "👱🏽‍♂️"),
            Friend("Катя", "👩🏼‍💼"),
            Friend("Леша", "👨‍🚀"),
            Friend("Женя", "👩‍🏭")
        ]
    }
}
