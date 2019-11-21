import UIKit


//MARK:- called from synchronizer
extension SectionedBasePresenter: SynchronizedPresenterProtocol {
   
    
    private func log(_ msg: String) {
        console(msg: msg, printEnum: .presenterCallsFromSync)
    }
    
    final func setView(vc: PushViewProtocol) {
        validateView(vc)
        view = vc as? PushSectionedViewProtocol
        let moduleEnum = ModuleEnum(presenter: self)
        if self.dataSourceIsEmpty() {
            view?.startWaitIndicator(moduleEnum)
        } else {
            filterAndRegroupData()
            view?.viewReloadData(groupByIds: self.groupByIds)
        }
    }
    
    final func dataSourceIsEmpty() -> Bool {
        return sortedDataSource.isEmpty
    }
    
    final func getDataSource() -> [ModelProtocol] {
        return sortedDataSource
    }
    
    final func clearDataSource() {
        sortedDataSource.removeAll()
    }
    
    // when response has got from network
    final func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion? = nil) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            PRESENTER_UI_THREAD {
                guard let self = self else { return }
                self.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
                self.log("SectionedBasePresenter: \(self.clazz): didSuccessNetworkResponse")
                completion?()
            }
        }
        return outerCompletion
    }
    
    
    // when all responses have got from network
    final func didSuccessNetworkFinish() {
        PRESENTER_UI_THREAD {
            self.log("SectionedBasePresenter: \(self.clazz): didSuccessNetworkFinish")
            self.sort()
            self.filterAndRegroupData()
            self.viewReloadData()
        }
    }
    
    final func setFromPersistent(models: [DecodableProtocol]) {
        PRESENTER_UI_THREAD {
            self.log("SectionedBasePresenter: \(self.clazz): setFromPersistent")
            self.appendDataSource(dirtyData: models, didLoadedFrom: .disk)
            self.sort()
            self.filterAndRegroupData()
            self.viewReloadData()
        }
    }
    
    func setSyncProgress(curr: Int, sum: Int) {
        PRESENTER_UI_THREAD {
            self.log("progress: \(curr) of \(sum)")
            if curr/sum * 100 % Network.intervalViewReload == 0 {
                self.sort()
                self.viewReloadData()
            }
        }
    }
}
