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
    
    
    func signIn(login: String, psw: String, onSuccess: ((String, String)->Void)?, onError: ((String)->Void)? ) {
        Auth.auth().signIn(withEmail: login, password: psw) { (success, err) in
            if let _ = success {
                onSuccess?(login, psw)
                return
            }
            if let error = err {
                onError?(error.localizedDescription)
            }
        }
    }
    
    
    func signUp(login: String, psw: String, onSuccess: ((String, String)->Void)?, onError: ((String)->Void)? ) {
        Auth.auth().createUser(withEmail: login, password: psw) { (success, err) in
            if let _ = success {
                RealmService.saveFirebaseCredentials(login: login, psw: psw)
                onSuccess?(login, psw)
                return
            }
            if let error = err {
                onError?(error.localizedDescription)
            }
        }
    }
}
