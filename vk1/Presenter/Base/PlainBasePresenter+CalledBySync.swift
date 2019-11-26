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
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.validateView(vc)
            self.view = vc as? PushPlainViewProtocol
            if self.dataSourceIsEmpty() {
                self.waitIndicator(start: true)
            } else {
                self.viewReloadData()
            }
        }
    }
    
    final func setFromPersistent(models: [DecodableProtocol]) {
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            let last = self.numberOfRowsInSection()
            self.log("setFromPersistent()", isErr: false)
            self.appendDataSource(dirtyData: models, didLoadedFrom: .disk)
            self.waitIndicator(start: false)
            
            self.pageInProgess = false
            //pagination:
            guard let _ = self as? PaginationPresenterProtocol
                  else { return }
            
            let slice = self.dataSource[last...]
            let endIndex = slice.endIndex-1 < 0 ? 0: slice.endIndex-1
            //no guarantee new data has appended:
            guard endIndex > slice.startIndex else { return }
            self.view?.insertItems(startIdx: slice.startIndex, endIdx: endIndex)
            
        }
    }
    
    func setSyncProgress(curr: Int, sum: Int) {
        PRESENTER_UI_THREAD { [weak self] in
            if curr/sum * 100 % Network.intervalViewReload == 0 {
                self?.viewReloadData()
            }
        }
    }
    
    //MARK:- did events:
    
    // when response has got from network
    final func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion? = nil) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            PRESENTER_UI_THREAD {
                guard let self = self else { return }
                let last = self.numberOfRowsInSection()
                
                self.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
                self.log("didSuccessNetworkResponse", isErr: false)
                completion?()
                
                self.waitIndicator(start: false)
                
                //pagination:
                guard let _ = self as? PaginationPresenterProtocol
                      else { return }
                
                let slice = self.dataSource[last...]
                let endIndex = slice.endIndex-1 < 0 ? 0: slice.endIndex-1
                //no guarantee new data has appended:
                guard endIndex > slice.startIndex else { return }
                self.view?.insertItems(startIdx: slice.startIndex, endIdx: endIndex)
            }
        }
        return outerCompletion
    }
    
    // when all responses have got from network
    final func didSuccessNetworkFinish() {
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.log("didSuccessNetworkFinish()", isErr: false)
            guard let child = self as? ModelOwnerPresenterProtocol
                       else {
                            self.log("didSuccessNetworkFinish(): self is not implemented ModelOwnerPresenterProtocol", isErr: true)
                            return
                       }
            if child.netFinishViewReload {
                self.viewReloadData()
            }
            self.pageInProgess = false
        }
    }
    
    final func didErrorNetworkFinish() {
        self.pageInProgess = false
    }
    

    private func log(_ msg: String, isErr: Bool) {
        if isErr {
            catchError(msg: "PlainBasePresenter: \(self.clazz): " + msg)
        } else {
            console(msg: "PlainBasePresenter: \(self.clazz): " + msg, printEnum: .presenterCallsFromSync)
        }
    }
}
