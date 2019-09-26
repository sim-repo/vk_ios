import Foundation
import UIKit

class Wall {
    var id: Int!
    var imageURLs: [String]?
    
    init(_ id: Int, _ imageURLs: [String]?){
        self.id = id;
        self.imageURLs = imageURLs
    }
    
    public class func list()->[Wall] {
        return [
            Wall(1, ["👓","🥭"]),
            Wall(2, ["🦈","🍺","🌰","🏑"]),
            Wall(3, ["🌿","🎻","🇹🇯"]),
            Wall(4, ["🍎","🇲🇦","📺","🏦","🛳"]),
            Wall(5, ["🍕","⛷"]),
            Wall(6, ["🎷","🧘🏽‍♂️","🏇🏻","🎯"]),
            Wall(7, ["🛰","🇺🇾","🇨🇩"]),
            Wall(8, ["🛵"]),
            Wall(9, ["🛰","🚜"]),
            Wall(10, ["🎟"]),
            
        ]
    }
}
