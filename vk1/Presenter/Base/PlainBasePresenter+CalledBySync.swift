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
    
    final func setView(vc: PushViewProtocol) {
        PRESENTER_UI_THREAD {
            self.validateView(vc)
            self.view = vc as? PushPlainViewProtocol
            if self.dataSourceIsEmpty() {
                self.view?.startWaitIndicator(nil)
            }
            guard self.dataSource.count > 0
                else { return }
            let moduleEnum = ModuleEnum(presenter: self)
            self.view?.viewReloadData(moduleEnum: moduleEnum)
        }
    }
    
    // when response has got from network
    final func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion? = nil) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            PRESENTER_UI_THREAD {
                guard let self = self else { return }
                self.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
                console(msg: "PlainBasePresenter: \(self.clazz): didSuccessNetworkResponse")
                completion?()
            }
        }
        return outerCompletion
    }
    
    // when all responses have got from network
    final func didSuccessNetworkFinish() {
        PRESENTER_UI_THREAD {
            console(msg: "PlainBasePresenter: \(self.clazz): didSuccessNetworkFinish")
            self.sort()
            self.viewReloadData()
        }
    }
    
    final func setFromPersistent(models: [DecodableProtocol]) {
        PRESENTER_UI_THREAD {
            console(msg: "PlainBasePresenter: \(self.clazz): setFromPersistent")
            self.appendDataSource(dirtyData: models, didLoadedFrom: .disk)
            self.sort()
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
