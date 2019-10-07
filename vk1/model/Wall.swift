import Foundation
import UIKit

class Wall : WallProtocol{
    var id: Int!
    var code: String!
    var imageURLs: [String]!
    var date: Date!
    var title: String?
    var likeCount = 0
    var viewCount = 0
    
    init(_ id: Int, _ code: String, _ imageURLs: [String]?){
        self.id = id;
        self.code = code
        self.imageURLs = imageURLs
    }
    
    func getImageURLs() -> [String] {
        return imageURLs
    }
    
    func getTitle() -> String? {
        return title
    }
    
    public class func list()->[Wall] {
        return [
            Wall(1, "tp1", ["pic1"]),
            Wall(2, "tp2", ["pic2","pic3"]),
            Wall(3, "tp3", ["pic3","pic10","pic16"]),
            Wall(4, "tp4", ["pic4","pic11","pic17","pic3"]),
            Wall(5, "tp5", ["pic4","pic11","pic17","pic3","pic14"]),
            Wall(6, "tp6", ["pic4","pic11","pic17","pic3","pic14","pic11"]),
            Wall(7, "tp7", ["pic4","pic11","pic17","pic3","pic14","pic11","pic14"]),
            Wall(8, "tp8", ["pic4","pic11","pic17","pic3","pic14","pic11","pic14","pic17"]),
            Wall(9, "tp9", ["pic4","pic11","pic17","pic3","pic14","pic11","pic14","pic17","pic20"])
//            Wall(5, "tp5", ["pic5","pic12","pic18","pic4","pic9","pic13"]),
//            Wall(6, "tp6", ["pic6","pic13","pic19","pic5","pic10","pic14","pic17"]),
//            Wall(7, "tp7", ["pic7","pic14","pic20","pic6","pic11","pic15","pic18","pic20"]),
//            Wall(8, "tp8", ["pic8","pic15","pic1","pic7","pic12","pic16","pic19","pic1","pic2"]),
        ]
    }
}
