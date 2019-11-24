import Foundation


typealias SyncBaseProtocol = SyncBase & SyncUserDefaultsProtocol

protocol SyncUserDefaultsProtocol {
    func sync(_ dispatchCompletion: (()->Void)?)
    func getId() -> String
}

class SyncBase {
        
    var syncStart: Date!
    var syncing = false
    var tryCount = 0
    
    func getLastSyncDate() -> Date? {
        guard let implement = self as? SyncBaseProtocol
        else {
            catchError(msg: "SyncBase(): getLastSyncDate(): SyncBaseProtocol is not implemented")
            return nil
        }
        return UserDefaults.standard.value(forKey: UserDefaultsEnum.lastSyncDate.rawValue + implement.getId()) as? Date
    }
    
    
    func setLastSyncDate(date: Date) {
        guard let implement = self as? SyncBaseProtocol
               else {
                    catchError(msg: "SyncBase(): setLastSyncDate(): SyncBaseProtocol is not implemented")
                    return
               }
        UserDefaults.standard.setValue(date, forKey: UserDefaultsEnum.lastSyncDate.rawValue + implement.getId())
    }
    
    
    func getCompletions(presenter: SynchronizedPresenterProtocol, _ dispatchCompletion: (()->Void)? = nil) ->
        (onSuccess_PresenterCompletion, onErrResponse_SyncCompletion) {
        
        let onSuccess_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
            
        let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse { [weak self] in
            onSuccess_SyncCompletion(presenter)
            dispatchCompletion?()
            self?.setLastSyncDate(date: Date())
            self?.syncing = false
        }

        
        let onError_SyncCompletion = SynchronizerManager.shared.getOnErrorCompletion() { [weak self] in
            dispatchCompletion?()
            self?.syncing = false
            if self!.tryCount < 3 {
               if let child = self as? SyncBaseProtocol {
                  child.sync(dispatchCompletion)
               }
               self!.tryCount+=1
            } else {
                catchError(msg: "SyncBase(): network request")
                
                self!.tryCount = 0
                presenter.didErrorNetworkFinish()
            }
        }
    
        return (onSuccess_PresenterCompletion, onError_SyncCompletion)
    }
}
