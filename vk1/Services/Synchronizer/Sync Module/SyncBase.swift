import Foundation


typealias SyncBaseProtocol = SyncBase & SyncUserDefaultsProtocol

protocol SyncUserDefaultsProtocol {
    var module: ModuleEnum { get }
    func sync(force: Bool, _ dispatchCompletion: (()->Void)?)
}

class SyncBase {
        
    var syncStart: Date!
    
    func getLastSyncDate() -> Date? {
        guard let child = self as? SyncBaseProtocol
        else {
            catchError(msg: "SyncBase(): getLastSyncDate(): SyncBaseProtocol is not implemented")
            return nil
        }
        return UserDefaults.standard.value(forKey: UserDefaultsEnum.lastSyncDate.rawValue + child.module.rawValue) as? Date
    }
    
    
    func setLastSyncDate(date: Date) {
        guard let child = self as? SyncBaseProtocol
               else {
                    catchError(msg: "SyncBase(): setLastSyncDate(): SyncBaseProtocol is not implemented")
                    return
               }
        UserDefaults.standard.setValue(date, forKey: UserDefaultsEnum.lastSyncDate.rawValue + child.module.rawValue)
    }
    
    
    func getCompletions(presenter: SynchronizedPresenterProtocol, _ dispatchCompletion: (()->Void)? = nil) ->
        (onSuccess_PresenterCompletion, onErrResponse_SyncCompletion) {
        
        let onSuccess_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
            
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse { [weak self] in
            onSuccess_SyncCompletion(presenter)
            dispatchCompletion?()
            self?.setLastSyncDate(date: Date())
        }

        let onError_SyncCompletion = SynchronizerManager.shared.getOnErrorCompletion() {
           dispatchCompletion?()
        }
            
        return (onSuccess_PresenterCompletion, onError_SyncCompletion)
    }
}
