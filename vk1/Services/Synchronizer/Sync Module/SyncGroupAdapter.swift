import UIKit

// #adapter
class SyncGroupAdapter: SyncBaseProtocol {
    
    static let shared = SyncGroupAdapter()
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
         ApiVKService.groupJoinRequest(groupId: groupId)
    }
    
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
        
        let presenter = PresenterFactory.shared.getInstance(clazz: GroupPresenter.self) // #adapter : КЛИЕНТ
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)  // #adapter : КЛИЕНТСКИЙ CLOSURE
        
        // #adapter : ВЫЗОВ СЕРВИСА
        ApiVKService.groupRequest(txtSearch: filter, onSuccess: onSuccess, onError: onError)
        
    }
}

