import UIKit


//MARK:- called from synchronizer
extension SectionedBasePresenter: SynchronizedPresenterProtocol {
   
    final func setView(vc: PushViewProtocol) {
        validateView(vc)
        view = vc as? PushSectionedViewProtocol
        if self.dataSourceIsEmpty() {
            view?.startWaitIndicator(nil)
        }
        filterAndRegroupData()
        view?.viewReloadData(groupByIds: self.groupByIds)
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
                console(msg: "SectionedBasePresenter: \(self.clazz): didSuccessNetworkResponse")
                completion?()
            }
        }
        return outerCompletion
    }
    
    
    // when all responses have got from network
    final func didSuccessNetworkFinish() {
        PRESENTER_UI_THREAD {
            console(msg: "SectionedBasePresenter: \(self.clazz): didSuccessNetworkFinish")
            self.sort()
            self.filterAndRegroupData()
            self.viewReloadData()
        }
    }
    
    
    final func setFromPersistent(models: [DecodableProtocol]) {
        PRESENTER_UI_THREAD {
            console(msg: "SectionedBasePresenter: \(self.clazz): setFromPersistent")
            self.appendDataSource(dirtyData: models, didLoadedFrom: .disk)
            self.sort()
            self.filterAndRegroupData()
            self.viewReloadData()
        }
    }
    
    func setSyncProgress(curr: Int, sum: Int) {
        console(msg: "progress: \(curr) of \(sum)")
        if curr/sum * 100 % Network.intervalViewReload == 0 {
            self.sort()
            self.viewReloadData()
        }
    }
}
