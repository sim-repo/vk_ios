import Foundation
import Firebase

class FirebaseService {
    
    private init(){}
    public static let shared = FirebaseService()
    
    lazy var fibUser: FIBUser = FIBUser(uid: "\(Session.shared.userId)", groupIds: [], ref: nil)
    let reference = Database.database().reference()
    
    func addGroup(groupId: String) {
        fibUser.groupIds.append(FIBGroup(groupId:groupId))
        let data = FirebaseService.shared.fibUser.toAnyObject()
        reference.child("Groups").setValue(data)
    }
}
