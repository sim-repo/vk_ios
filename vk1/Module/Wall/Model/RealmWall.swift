import Foundation
import RealmSwift

class RealmWall: RealmBase {
    
    
    @objc dynamic var type = ""
    @objc dynamic var ownerId = 0
    
    // wall header block
    @objc dynamic var reposterId = 0
    @objc dynamic var reposterAvaURL = ""
    @objc dynamic var reposterName: String = ""
    @objc dynamic var reposterPostDate: Double = 0
    @objc dynamic var reposterTitle: String = ""
    
    
    @objc dynamic var authorId = 0
    @objc dynamic var authorAvaURL = ""
    @objc dynamic var authorName: String = ""
    @objc dynamic var authorPostDate: Double = 0
    @objc dynamic var authorTitle: String = ""

    // wall image block
    var imageURLs = List<RealmURL>()

    // wall bottom block
    @objc dynamic var likeCount = 0
    @objc dynamic var viewCount = 0
    @objc dynamic var messageCount = 0
    @objc dynamic var shareCount = 0

    @objc dynamic var offset = 0
}
