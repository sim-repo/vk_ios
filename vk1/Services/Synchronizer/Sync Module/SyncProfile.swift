import UIKit

class SyncProfile: SyncBaseProtocol {
    
    static let shared = SyncProfile()
    private override init() {}
       
    var module: ModuleEnum {
        return ModuleEnum.profile
    }
    
    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        //TODO:
    }
}
    
