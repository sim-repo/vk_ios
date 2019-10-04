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
            Wall(1, ["pic1"]),
            Wall(2, ["pic2","pic9"]),
            Wall(3, ["pic3","pic10","pic16","pic2"]),
            Wall(4, ["pic4","pic11","pic17","pic3","pic8"]),
            Wall(5, ["pic5","pic12","pic18","pic4","pic9","pic13"]),
            Wall(6, ["pic6","pic13","pic19","pic5","pic10","pic14","pic17"]),
            Wall(7, ["pic7","pic14","pic20","pic6","pic11","pic15","pic18","pic20"]),
            Wall(8, ["pic8","pic15","pic1","pic7","pic12","pic16","pic19","pic1","pic2"]),
        ]
    }
}
