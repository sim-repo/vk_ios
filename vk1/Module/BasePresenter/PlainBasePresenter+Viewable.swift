import Foundation

//MARK:- called from view

extension PlainBasePresenter : ViewablePlainPresenterProtocol {
    
    
    //MARK:- getters:
    
    final func numberOfRowsInSection() -> Int {
        return dataSource.count
    }
    
    final func getData(indexPath: IndexPath? = nil) -> ModelProtocol? {
        // for non-list DS
        if indexPath == nil {
            guard dataSource.count == 1
                else {
                    log("getData(): datasource must be 1", level: .error)
                    return nil
            }
            return dataSource[0]
        }
        
        // else for list DS
        guard let idx = indexPath
            else { return nil }
        guard dataSource.count > idx.row
            else {
                return nil
        }
        return dataSource[idx.row]
    }
    
    
    final func getIndexPath(model: ModelProtocol) -> IndexPath?{
        guard let idx = dataSource.firstIndex(where: { $0.getId() == model.getId() })
            else {return nil}
        
        return IndexPath(row: idx, section: 0)
    }
    
    
    //MARK:- did events:
    
    func didEndScroll() {
        SEQ_THREAD {  [weak self] in
            guard let self = self else { return }
            guard !self.paginationInProgess else {
                self.log("didEndScroll(): pageInProgress == false", level: .info)
                return
            }
    
            self.paginationInProgess = true
            guard let _ = self as? PaginablePresenterProtocol else { return }
            self.log("didEndScroll(): started", level: .info)
            self.synchronizer?.tryRunSync()
        }
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "PlainBasePresenter: \(self.clazz): ", msg, level: level, printEnum: .presenterCallsFromView)
    }
}
