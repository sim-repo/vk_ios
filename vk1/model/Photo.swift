import Foundation

class Photo {
    var id: Int!
    var image: String!

    
    init(_ id: Int, _ image: String){
        self.id = id;
        self.image = image
    }
    
    public class func list()->[Photo] {
        return [
            Photo(1, "👓"),
            Photo(2, "🦈"),
            Photo(3, "🌿"),
            Photo(4, "🍎"),
            Photo(5, "🍕"),
            Photo(6, "🎷"),
            Photo(7, "🛰")
        ]
    }
}
