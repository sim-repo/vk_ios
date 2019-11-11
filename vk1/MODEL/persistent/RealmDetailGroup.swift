import Foundation
import RealmSwift

class RealmDetailGroup: Object {
    
    // get from network >>
    @objc dynamic var id: Double = 0
    @objc dynamic var photosCounter: Int = 0
    @objc dynamic var albumsCounter: Int = 0
    @objc dynamic var topicsCounter: Int = 0
    @objc dynamic var videosCounter: Int = 0
    @objc dynamic var marketCounter: Int = 0
    @objc dynamic var coverURL400: String = ""

    // set from MyGroup class >>
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var avaURL50: String = ""
    @objc dynamic var avaURL200: String = ""
    @objc dynamic var membersCount: Int = 0
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var isDeactivated: Int = 0
}
