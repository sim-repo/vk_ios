import UIKit

class SyncLogin {

    static let shared = SyncLogin()
    private init() {}
    
    func sync(force: Bool) {
        SyncWall.shared.sync(force: force)
    }
}
