import Foundation
import RealmSwift

class RealmFriend: Object {
    
    @objc dynamic var id: Double = 0.0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avaURL50: String = ""
    @objc dynamic var avaURL100: String = ""
    @objc dynamic var avaURL200: String = ""
    @objc dynamic var groupBy: String = FriendGroupByEnum.firstName.rawValue
}
