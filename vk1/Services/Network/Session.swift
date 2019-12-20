import Foundation


class Session {
    static let shared = Session()
    
    private init(){}
    
    var token = ""
    var userId = ""

    func set(_ token: String, _ userId: String) {
        self.token = token
        self.userId = userId
    }
}

