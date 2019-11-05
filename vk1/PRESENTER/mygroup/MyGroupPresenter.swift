import Foundation
import Alamofire

class MyGroupPresenter: SectionPresenterProtocols {

    // implements ModelOwnerProtocol
    var modelClass: AnyClass  {
        return MyGroup.self
    }
    
    func addGroup(group: Group) -> Bool {
        let has = sortedDataSource.contains {$0.getId() == group.id}
        guard !has
            else { return false }
        appendDataSource(dirtyData: [group], didLoadedFrom: .network)
        return true
    }
    
    func removeGroup(indexPath: IndexPath) {
        sortedDataSource.remove(at: indexPath.row)
    }
}
