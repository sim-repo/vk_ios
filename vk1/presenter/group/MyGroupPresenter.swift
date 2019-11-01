import Foundation
import Alamofire

public class MyGroupPresenter: SectionedBasePresenter{

    override func subscribe(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.addModel(_:)), name: .groupInserted, object: nil)
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
    
    //MARK: override func
    override func validate(_ ds: [DecodableProtocol]) {
        guard ds is [MyGroup]
        else {
            catchError(msg: "MyGroupPresenter: validate()")
            return
        }
    }
}


extension MyGroupPresenter: BasicNetworkProtocol {
    func datasourceIsEmpty() -> Bool {
        return sortedDataSource.isEmpty
    }
}
