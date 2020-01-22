import Foundation
//import RealmSwift

class RealmMyGroup: RealmBase {
    
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var avaURL50: String = ""
    @objc dynamic var avaURL200: String = ""
    @objc dynamic var coverURL400: String = ""
    @objc dynamic var membersCount: Int = 0
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var isDeactivated: Int = 0
}
