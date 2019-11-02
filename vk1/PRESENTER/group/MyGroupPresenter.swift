import Foundation
import Alamofire

class MyGroupPresenter: HybridSectionedPresenter {

    // implements ModelOwnerProtocol
    var modelClass: AnyClass  {
        return MyGroup.self
    }

    func getIndexPath() -> IndexPath {
        let rowIndex = sortedDataSource.count - 1
        return IndexPath(row: rowIndex, section: 0)
    }
    
    func onPerfomSegue_Details(selected indexPath: IndexPath) {
        guard let group = getData(indexPath: indexPath) as? MyGroup
            else {
                catchError(msg: "MyGroupPresenter: onPerfomSegue_Details")
                return
            }
        let groupDetailPresenter: MyGroupDetailPresenter? = PresenterFactory.shared.getInstance()
        groupDetailPresenter?.setGroup(group: group)
    }
    
    func addGroup(group: Group) -> Bool {
        let has = sortedDataSource.contains {$0.getId() == group.id}
        guard !has
            else { return false }
        
        //groups.append(MyGroup(group: group))
        return true
    }
    
    func removeGroup(indexPath: IndexPath) {
        sortedDataSource.remove(at: indexPath.row)
    }
}
