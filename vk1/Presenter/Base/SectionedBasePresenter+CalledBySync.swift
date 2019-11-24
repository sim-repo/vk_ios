import UIKit


//MARK:- called from synchronizer
extension SectionedBasePresenter: SynchronizedPresenterProtocol {

    
    //MARK:- getters:
    
    final func getDataSource() -> [ModelProtocol] {
        return sortedDataSource
    }
    
    final func dataSourceIsEmpty() -> Bool {
        return sortedDataSource.isEmpty
    }
    
    
    //MARK:- setters:
    
    final func clearDataSource(id: typeId? = nil) {
        clearCache(id: id, predicateEnum: .equal)
        RealmService.delete(moduleEnum: moduleEnum, id: id)
        SynchronizerManager.shared.didClearDataSource(moduleEnum: moduleEnum)
    }
    
    final func setView(vc: PushViewProtocol) {
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.validateView(vc)
            self.view = vc as? PushSectionedViewProtocol
            if self.dataSourceIsEmpty() {
                self.waitIndicator(start: true)
            } else {
                self.filterAndRegroupData()
                self.view?.viewReloadData(groupByIds: self.groupByIds)
            }
        }
    }
    

    
    //MARK:- did events:
    
    // when response has got from network
    final func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion? = nil) -> onSuccess_PresenterCompletion {
        let outerCompletion: onSuccess_PresenterCompletion = {[weak self] (arr: [DecodableProtocol]) in
            PRESENTER_UI_THREAD {
                guard let self = self else { return }
                self.appendDataSource(dirtyData: arr, didLoadedFrom: .network)
                self.log("didSuccessNetworkResponse()", isErr: false)
                completion?()
                
                self.waitIndicator(start: false)
            }
        }
        return outerCompletion
    }
    
    
    // when all responses have got from network
    final func didSuccessNetworkFinish() {
        PRESENTER_UI_THREAD {[weak self] in
            guard let self = self else { return }
            self.log("didSuccessNetworkFinish()", isErr: false)
            self.sort()
            self.filterAndRegroupData()
            self.viewReloadData()
            self.pageInProgess = false
        }
    }
    
    final  func didErrorNetworkFinish() {
        self.pageInProgess = false
    }
    
    final func setFromPersistent(models: [DecodableProtocol]) {
        PRESENTER_UI_THREAD {[weak self] in
            guard let self = self else { return }
            self.log("setFromPersistent()", isErr: false)
            self.appendDataSource(dirtyData: models, didLoadedFrom: .disk)
            self.sort()
            self.filterAndRegroupData()
            self.viewReloadData()
        }
    }
    
    func setSyncProgress(curr: Int, sum: Int) {
        PRESENTER_UI_THREAD { [weak self] in
            if curr/sum * 100 % Network.intervalViewReload == 0 {
                self?.sort()
                self?.viewReloadData()
            }
        }
    }
    
    
    private func log(_ msg: String, isErr: Bool) {
         if isErr {
             catchError(msg: "SectionBasePresenter: \(self.clazz): " + msg)
         } else {
             console(msg: "SectionBasePresenter: \(self.clazz): " + msg, printEnum: .presenterCallsFromSync)
         }
     }
}
