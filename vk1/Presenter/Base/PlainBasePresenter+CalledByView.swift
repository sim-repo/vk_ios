import UIKit



//MARK:- called from view
extension PlainBasePresenter: PullPlainPresenterProtocol {
    
    
    private func log(_ msg: String) {
        console(msg: msg, printEnum: .presenterCallsFromView)
    }
    
    final func numberOfRowsInSection() -> Int {
        return dataSource.count
    }
    
    @objc func viewDidDisappear() {
        SynchronizerManager.shared.viewDidDisappear(presenter: self)
    }
    
    func viewDidFilterInput(_ filterText: String) {
    }
    
    func getSectionChild() -> PullSectionPresenterProtocol? {
        return sectionChildPresenter
    }
    
    func getPlainChild() -> PullPlainPresenterProtocol? {
        return plainChildPresenter
    }
    
    func viewDidSeguePrepare(segueId: SegueIdEnum, indexPath: IndexPath) {
        
        guard let model = getData(indexPath: indexPath)
            else {
                catchError(msg: "PlainBasePresenter: \(clazz): viewDidSeguePrepare(): no data with indexPath: \(indexPath)")
                return
        }
        
        guard let detailPresenter = PresenterFactory.shared.getInstance(segueId: segueId) as? DetailPresenterProtocol
            else {
                catchError(msg: "PlainBasePresenter: \(clazz): viewDidSeguePrepare(): can't get detailPresenter by segueId: \(segueId.rawValue) ")
                return
        }
        detailPresenter.setParentModel(model: model)
    }
    
    
    final func getData(indexPath: IndexPath? = nil) -> ModelProtocol? {
        // for non-list DS
        if indexPath == nil {
            guard dataSource.count == 1
                else {
                    catchError(msg: "PlainBasePresenter: \(clazz): getData(): datasource must be 1")
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
    
    func didEndScroll(){
        guard !pageInProgess else { return }
        pageInProgess = true
        guard let _ = self as? PaginationPresenterProtocol
            else { return }
        log("PlainBasePresenter(): \(clazz): didEndScroll()")
        SynchronizerManager.shared.callSyncFromPresenter(moduleEnum: moduleEnum)
    }
}
