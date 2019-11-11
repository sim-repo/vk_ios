import Foundation
import RealmSwift

class RealmWall: Object {
    
    @objc dynamic var id = 0.0
    @objc dynamic var postTypeCode = ""
    
    
    // wall header block
    @objc dynamic var myAvaURL = ""
    @objc dynamic var myName: String = ""
    @objc dynamic var myPostDate: Double = 0
    @objc dynamic var title: String = ""

    @objc dynamic var origAvaURL = ""
    @objc dynamic var origName: String = ""
    @objc dynamic var origPostDate: Double = 0
    @objc dynamic var origTitle: String = ""

    // wall image block
    var imageURLs = List<RealmURL>()

    // wall bottom block
    @objc dynamic var likeCount = 0
    @objc dynamic var viewCount = 0
    @objc dynamic var messageCount = 0
    @objc dynamic var shareCount = 0

}
