import Foundation
import Firebase


struct FIBGroup: Codable {
    let groupId: String?
    
    var toAnyObject: Any {
        return [
            "groupId": groupId
        ]
    }
}



struct FIBUser {
    let uid: String
    var groupIds: [FIBGroup] = []
    let ref: DatabaseReference?
    
    
    func toAnyObject() -> Any {
        return [
                "uid": uid,
                "groups":groupIds.map{ $0.toAnyObject}
        ]
    }
}

