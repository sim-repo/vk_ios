import UIKit



//MARK:- called from view
extension PlainBasePresenter: PullPlainPresenterProtocol {
    
    
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
    
    //complex:
    func getSubSectionPresenter() -> PullSectionPresenterProtocol? {
        return subSectionPresenter
    }
    
    func getSubPlainPresenter() -> PullPlainPresenterProtocol? {
        return subPlainPresenter
    }
    
    
    
    //MARK:- did events:
    
    func viewDidSeguePrepare(segueId: ModuleEnum.SegueIdEnum, indexPath: IndexPath) {
        
        guard let model = getData(indexPath: indexPath)
            else {
                log("viewDidSeguePrepare(): no data with indexPath: \(indexPath)", level: .error)
                return
        }
        
        guard let detailPresenter = PresenterFactory.shared.getInstance(segueId: segueId) as? DetailPresenterProtocol
            else {
                log("viewDidSeguePrepare(): can't get detailPresenter by segueId: \(segueId.rawValue)", level: .error)
                return
        }
        detailPresenter.setParentModel(model: model)
    }
    
    @objc func viewDidLoad() {
        
    }
    
    @objc func viewDidDisappear() {
        SyncMgt.shared.viewDidDisappear(presenter: self)
    }
    
    func viewDidFilterInput(_ filterText: String) {
        
        if let implement = self as? DetailPresenterProtocol,
           let id = implement.getId() {
            clearCache(id: id, predicateEnum: .equal)
        } else {
            clearCache()
        }
        SyncMgt.shared.doFilter(filter: filterText, moduleEnum: moduleEnum)
    }
    
    
    final func didEndScroll(){
        guard !pageInProgess else {
            log("didEndScroll(): pageInProgress == false", level: .info)
            return
        }
        pageInProgess = true
        guard let _ = self as? PaginationPresenterProtocol else { return }
        log("didEndScroll(): started", level: .info)
        SyncMgt.shared.doSync(moduleEnum: moduleEnum)
    }
    
    
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        switch level {
        case .info:
            Logger.console(msg: "PlainBasePresenter: \(self.clazz): " + msg, printEnum: .presenterCallsFromView)
        case .warning:
            Logger.catchWarning(msg: "PlainBasePresenter: \(self.clazz): " + msg)
        case .error:
            Logger.catchError(msg: "PlainBasePresenter: \(self.clazz): " + msg)
        }
    }
}
