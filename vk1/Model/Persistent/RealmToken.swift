import Foundation
import RealmSwift

class RealmToken: RealmBase {
    @objc dynamic var token = ""
    @objc dynamic var userId = ""
}
