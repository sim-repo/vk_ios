import UIKit

class SyncGroup: SyncBaseProtocol {
    
    static let shared = SyncGroup()
    private override init() {}
    
    public func getId() -> String {
        return ModuleEnum.group.rawValue
    }
    
    var filter = ""
    
    public func search(filter: String) {
        self.filter = filter
        sync()
    }
    
    
    public func join(groupId: String) {
         ApiVK.groupJoinRequest(groupId: groupId)
    }
    
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: GroupPresenter.self)
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
        
        ApiVK.groupRequest(txtSearch: filter, onSuccess: onSuccess, onError: onError)
        
    }
}

