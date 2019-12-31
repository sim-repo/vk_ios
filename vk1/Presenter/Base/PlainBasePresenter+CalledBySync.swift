import UIKit

//MARK:- called from synchronizer & presenter factory
extension PlainBasePresenter: SynchronizedPresenterProtocol {
    
    
    //MARK:- getters:
    
    final func getDataSource() -> [ModelProtocol] {
        return dataSource
    }
    
    final func dataSourceIsEmpty() -> Bool {
        return dataSource.isEmpty
    }
    
    
    //MARK:- setters:
    
    final func clearDataSource(id: typeId? = nil) {
       clearCache(id: id, predicateEnum: .equal)
       RealmService.delete(moduleEnum: moduleEnum, id: id)
       SyncMgt.shared.didClearDataSource(moduleEnum: moduleEnum)
    }
    
    final func setView(vc: PushViewProtocol) {
        validateView(vc)
        view = vc as? PushPlainViewProtocol
        if dataSourceIsEmpty() {
            waitIndicator(start: true)
        } else {
            viewReloadData()
        }
    }
    
    final func setFromPersistent(models: [DecodableProtocol]) {
        let last = self.numberOfRowsInSection()
        log("setFromPersistent()", level: .info)
        appendDataSource(dirtyData: models, didLoadedFrom: .disk)
        waitIndicator(start: false)
        
        pageInProgess = false
        //pagination:
        guard let _ = self as? PaginationPresenterProtocol
              else { return }
        
        let slice = dataSource[last...]
        let endIndex = slice.endIndex-1 < 0 ? 0: slice.endIndex-1
        //no guarantee new data has appended:
        guard endIndex > slice.startIndex else { return }
        view?.insertItems(startIdx: slice.startIndex, endIdx: endIndex)
    }
    
    func setSyncProgress(curr: Int, sum: Int) {
        if curr/sum * 100 % NetworkConstant.intervalViewReload == 0 {
            viewReloadData()
        }
    }
    
    //MARK:- did events:
    
    // when response has got from network
    final func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion? = nil) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
        
                guard let self = self else { return }
                let last = self.numberOfRowsInSection()
                
                self.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
                self.log("didSuccessNetworkResponse", level: .info)
                completion?()
                
                self.waitIndicator(start: false)
                
                //pagination:
                guard let _ = self as? PaginationPresenterProtocol
                      else { return }
                
                let slice = self.dataSource[last...]
                let endIndex = slice.endIndex-1 < 0 ? 0: slice.endIndex-1
                //no guarantee new data has appended:
                guard endIndex >= slice.startIndex else { return }
                self.view?.insertItems(startIdx: slice.startIndex, endIdx: endIndex)
            }
        return outerCompletion
    }
    
    // when all responses have got from network
    final func didSuccessNetworkFinish() {

        log("didSuccessNetworkFinish()", level: .info)
        guard let child = self as? ModelOwnerPresenterProtocol
                   else {
                        log("didSuccessNetworkFinish(): self is not implemented ModelOwnerPresenterProtocol", level: .error)
                        return
                   }
        if child.netFinishViewReload {
            viewReloadData()
        }
        pageInProgess = false
    }
    
    final func didErrorNetworkFinish() {
        pageInProgess = false
    }
    
    
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        switch level {
        case .info:
            Logger.console(msg: "PlainBasePresenter: \(self.clazz): " + msg, printEnum: .presenterCallsFromSync)
        case .warning:
            Logger.catchWarning(msg: "PlainBasePresenter: \(self.clazz): " + msg)
        case .error:
            Logger.catchError(msg: "PlainBasePresenter: \(self.clazz): " + msg)
        }
    }
}
