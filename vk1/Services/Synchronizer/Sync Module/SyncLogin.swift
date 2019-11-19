import UIKit

class SyncLogin: SyncBaseProtocol {

    static let shared = SyncLogin()
    private override init() {}
       
    var module: ModuleEnum {
        return ModuleEnum.login
    }
    
    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        
     //   SyncWall.shared.sync(force: force)
    }
}
