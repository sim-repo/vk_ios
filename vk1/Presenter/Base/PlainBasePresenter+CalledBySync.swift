import UIKit

//MARK:- called from synchronizer & presenter factory
extension PlainBasePresenter: SynchronizedPresenterProtocol {
    
    final func getDataSource() -> [ModelProtocol] {
        return dataSource
    }
    
    final func dataSourceIsEmpty() -> Bool {
        return dataSource.isEmpty
    }
    
    final func clearDataSource() {
       dataSource.removeAll()
    }
    
    private func log(_ msg: String) {
        console(msg: msg, printEnum: .presenterCallsFromSync)
    }
    
    final func setView(vc: PushViewProtocol) {
        PRESENTER_UI_THREAD {
            self.validateView(vc)
            self.view = vc as? PushPlainViewProtocol
            if self.dataSourceIsEmpty() {
                self.waitIndicator(start: true)
            } else {
                self.viewReloadData()
            }
        }
    }
    
    // when response has got from network
    final func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion? = nil) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            PRESENTER_UI_THREAD {
                guard let self = self else { return }
                let last = self.numberOfRowsInSection()
                
                self.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
                self.log("PlainBasePresenter: \(self.clazz): didSuccessNetworkResponse")
                completion?()
                
                self.waitIndicator(start: false)
                
                //pagination:
                guard let _ = self as? PaginationPresenterProtocol
                      else { return }
                
                let z = self.dataSource[last...]
                let endIndex = z.endIndex-1 < 0 ? 0: z.endIndex-1
                self.view?.insertItems(startIdx: z.startIndex, endIdx: endIndex)
            }
        }
        return outerCompletion
    }
    
    // when all responses have got from network
    final func didSuccessNetworkFinish() {
        PRESENTER_UI_THREAD {
            self.log("PlainBasePresenter: \(self.clazz): didSuccessNetworkFinish")
            if self.child.netFinishViewReload {
                self.viewReloadData()
            }
            self.paginatingInProgess = false
        }
    }
    
    final func setFromPersistent(models: [DecodableProtocol]) {
        PRESENTER_UI_THREAD {
            self.log("PlainBasePresenter: \(self.clazz): setFromPersistent")
            self.appendDataSource(dirtyData: models, didLoadedFrom: .disk)
            self.viewReloadData()
        }
    }
    
    func setSyncProgress(curr: Int, sum: Int) {
        PRESENTER_UI_THREAD {
            if curr/sum * 100 % Network.intervalViewReload == 0 {
                self.viewReloadData()
            }
        }
    }
}
