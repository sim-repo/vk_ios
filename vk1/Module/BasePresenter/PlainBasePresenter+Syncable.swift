import Foundation

//MARK:- called from synchronizer

extension PlainBasePresenter : SyncablePresenterProtocol {
    
    func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion?) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [ModelProtocol]) in
            guard let self = self else { return }
            let last = self.numberOfRowsInSection()
            
            self.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
            self.log("didSuccessNetworkResponse", level: .info)
            completion?()
            
            self.waitIndicator(start: false)
            
            //pagination:
            guard let _ = self as? PaginablePresenterProtocol
                else { return }
            
            let slice = self.dataSource[last...]
            let endIndex = slice.endIndex-1 < 0 ? 0: slice.endIndex-1
            //no guarantee new data has appended:
            guard endIndex >= slice.startIndex else { return }
            self.getView()?.insertItems(startIdx: slice.startIndex, endIdx: endIndex)
        }
        return outerCompletion
    }
    
    func didSuccessNetworkFinish() {
        log("didSuccessNetworkFinish()", level: .info)
        let implement = self as! SyncablePresenterParametersProtocol
        if implement.isViewReloadWhenNetFinish {
            if let sortable = self as? SortablePresenterProtocol {
                sortable.sort()
            }
            viewReloadData()
        }
        paginationInProgess = false
    }
    
    func didErrorNetworkFinish() {
        paginationInProgess = false
    }
    
    func setFromPersistent(models: [ModelProtocol]) {
        let last = self.numberOfRowsInSection()
        log("setFromPersistent()", level: .info)
        appendDataSource(dirtyData: models, didLoadedFrom: .disk)
        waitIndicator(start: false)
        
        paginationInProgess = false
        //pagination:
        guard let _ = self as? PaginablePresenterProtocol
            else { return }
        
        let slice = dataSource[last...]
        let endIndex = slice.endIndex-1 < 0 ? 0: slice.endIndex-1
        //no guarantee new data has appended:
        guard endIndex > slice.startIndex else { return }
        getView()?.insertItems(startIdx: slice.startIndex, endIdx: endIndex)
    }
    
    func clearDataSource(id: Int?) {
        clearCache(id: id, predicateEnum: .equal)
        RealmService.delete(moduleEnum: getModule(), id: id)
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "PlainBasePresenter: \(self.clazz): ", msg, level: level, printEnum: .sync)
    }
}

