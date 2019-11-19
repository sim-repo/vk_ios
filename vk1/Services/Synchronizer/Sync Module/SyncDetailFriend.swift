import UIKit

class SyncDetailFriend: SyncBaseProtocol {
    
    static let shared = SyncDetailFriend()
    private override init() {}
    
    var module: ModuleEnum {
        return ModuleEnum.friend_wall
    }
    
    func sync(force: Bool, _ dispatchCompletion: (() -> Void)?) {
        //TODO:
    }
}
    
