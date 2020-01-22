import Foundation

//MARK:- called from synchronizer

extension SectionedBasePresenter : SyncablePresenterProtocol {
    
    func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion?) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [ModelProtocol]) in
            guard let self = self else { return }
            self.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
            self.log("didSuccessNetworkResponse()", level: .info)
            completion?()
            
            self.waitIndicator(start: false)
        }
        return outerCompletion
    }
    
    func didSuccessNetworkFinish() {
        log("didSuccessNetworkFinish()", level: .info)
        if let sortable = self as? SortablePresenterProtocol {
            sortable.sort()
        }
        filterAndRegroupData()
        viewReloadData()
        paginationInProgess = false
    }
    
    func didErrorNetworkFinish() {
        paginationInProgess = false
    }
    
    func setFromPersistent(models: [ModelProtocol]) {
        log("setFromPersistent()", level: .info)
        appendDataSource(dirtyData: models, didLoadedFrom: .disk)
        if let sortable = self as? SortablePresenterProtocol {
            sortable.sort()
        }
        filterAndRegroupData()
        viewReloadData()
    }
    
    func clearDataSource(id: Int?) {
        clearCache(id: id, predicateEnum: .equal)
        RealmService.delete(moduleEnum: getModule(), id: id)
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "SectionedBasePresenter: \(self.clazz): ", msg, level: level, printEnum: .sync)
    }
}
