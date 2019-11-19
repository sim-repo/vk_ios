import UIKit


//MARK:- called from view
extension SectionedBasePresenter: PullSectionPresenterProtocol {
    
    final func numberOfSections() -> Int {
        return sectionsOffset.count > 0 ? sectionsOffset.count : 1
    }
    
    
    final func numberOfRowsInSection(section: Int) -> Int {
        guard sectionsOffset.count > 0
            else {
                return sortedDataSource.count
        }
        let offset = sectionsOffset[section]
        
        guard numberOfSections() > section + 1
            else {
                return sortedDataSource.count - offset
        }
        
        let next = sectionsOffset[section+1]
        return next - offset
    }
    
    
    final func getSectionChild() -> PullSectionPresenterProtocol? {
        return sectionChild
    }
    
    
    final func getPlainChild() -> PullPlainPresenterProtocol? {
        return plainChild
    }
    
    
    final func sectionTitle(section: Int)->String {
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
    
    
    final func getData(indexPath: IndexPath? = nil) -> ModelProtocol? {
        guard let idxPath = indexPath
        else {
            catchError(msg: "SectionedBasePresenter: \(clazz): getData(indexPath:) argument is nil")
            return nil
        }
        guard sectionsOffset.count > 0
            else {
                return sortedDataSource[idxPath.row]
        }
        let offset = sectionsOffset[idxPath.section]
        
        guard sortedDataSource.count > offset + idxPath.row
            else {
                return nil
        }
        
        return sortedDataSource[offset + idxPath.row]
    }
    
    
    final func getIndexPath(model: ModelProtocol) -> IndexPath?{
        
        guard let sortedIdx = sortedDataSource.firstIndex(where: { $0.getId() == model.getId() })
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
    
    
    final func viewDidFilterInput(_ searchText: String) {
        filteredText = !searchText.isEmpty ? searchText : nil
        filterAndRegroupData()
        self.view?.viewReloadData(groupByIds: self.groupByIds)
    }
    
    
    final func viewDidDisappear() {
        SynchronizerManager.shared.viewDidDisappear(presenter: self)
    }
    
    
    final func viewDidSeguePrepare(segueId: SegueIdEnum, indexPath: IndexPath) {
      
        guard let model = getData(indexPath: indexPath)
                    else {
                        catchError(msg: "SectionedBasePresenter: \(clazz): viewDidSeguePrepare(): no data with indexPath: \(indexPath)")
                        return
                    }
        
        guard let detailPresenter = PresenterFactory.shared.getInstance(segueId: segueId) as? DetailPresenterProtocol
            else {
                catchError(msg: "SectionedBasePresenter: \(clazz): viewDidSeguePrepare(): can't get detailPresenter by segueId: \(segueId.rawValue) ")
                return
            }
        detailPresenter.setDetailModel(model: model)
    }
}
