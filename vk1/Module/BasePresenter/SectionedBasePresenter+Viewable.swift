import Foundation

//MARK:- called from view

extension SectionedBasePresenter : ViewableSectionPresenterProtocol {
    
    //MARK:- getters:
    
    final func numberOfSections() -> Int {
        return sectionsOffset.count > 0 ? sectionsOffset.count : 1
    }
    
    
    final func numberOfRowsInSection(section: Int) -> Int {
        guard sectionsOffset.count > 0
            else {
                return dataSource.count
        }
        let offset = sectionsOffset[section]
        
        guard numberOfSections() > section + 1
            else {
                return dataSource.count - offset
        }
        
        let next = sectionsOffset[section+1]
        return next - offset
    }
    
    
    final func getSectionTitle(section: Int) -> String {
        guard sectionsTitle.count > 0
            else {
                return "A"
        }
        let idx = sectionsTitle[section].rawValue
        return String(Alphabet.titles[idx])
    }
    
    
    final func getGroupBy() -> [String] {
        return groupByIds
    }
    
    
    final func getData(indexPath: IndexPath?) -> ModelProtocol? {
        guard let idxPath = indexPath
        else {
            log("getData(indexPath:) argument is nil", level: .error)
            return nil
        }
        guard sectionsOffset.count > 0
            else {
                return dataSource[idxPath.row]
        }
        let offset = sectionsOffset[idxPath.section]
        
        guard dataSource.count > offset + idxPath.row
            else {
                return nil
        }
        return dataSource[offset + idxPath.row]
    }
    
    
    func getIndexPath(model: ModelProtocol) -> IndexPath? {
        guard let sortedIdx = dataSource.firstIndex(where: { $0.getId() == model.getId() })
            else {return nil}
        
        if sectionsOffset.count == 0 {
            return IndexPath(row: sortedIdx, section: 0)
        }
        
        guard let sectionIdx = sectionsOffset.firstIndex(where: { $0 > sortedIdx })
            else {return nil}
        guard sectionIdx > 0
            else {return nil}
        
        let offset = sectionsOffset[sectionIdx-1]
        
        let row = sortedIdx - offset
        
        return IndexPath(row: row, section: sectionIdx-1)
    }
    
    
    func didEndScroll() {
        guard !paginationInProgess else {
            log("didEndScroll(): pageInProgress == false", level: .info)
            return
        }
        paginationInProgess = true
        guard let _ = self as? PaginablePresenterProtocol else { return }
        log("didEndScroll(): started", level: .info)
        self.synchronizer?.tryRunSync()
    }
    
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "SectionBasePresenter: \(self.clazz): ", msg, level: level, printEnum: .presenterCallsFromView)
    }
}
