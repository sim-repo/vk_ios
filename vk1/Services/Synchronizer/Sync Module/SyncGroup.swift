import UIKit

class SyncGroup: SyncBaseProtocol {
    
    static let shared = SyncGroup()
    private override init() {}
       
    var module: ModuleEnum {
        return ModuleEnum.group
    }
    
    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        //TODO:
    }
}
    
