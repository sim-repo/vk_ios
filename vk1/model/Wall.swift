import Foundation

class Wall {
    var id: Int!
    var image: String!
    
    
    init(_ id: Int, _ image: String){
        self.id = id;
        self.image = image
    }
    
    public class func list()->[Wall] {
        return [
            Wall(1, "👓"),
            Wall(2, "🦈"),
            Wall(3, "🌿"),
            Wall(4, "🍎"),
            Wall(5, "🍕"),
            Wall(6, "🎷"),
            Wall(7, "🛰")
        ]
    }
}
