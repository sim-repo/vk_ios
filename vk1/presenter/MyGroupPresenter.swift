import Foundation
import Alamofire

public class MyGroupPresenter: SectionedBasePresenter{
    
    let urlPath: String = "groups.get"
    
    override func loadFromNetwork(completion: (()->Void)? = nil){
           let params: Parameters = [
               "access_token": Session.shared.token,
               "extended": "1",
               "fields":["description","members_count","photo_50","photo_200"],
               "v": "5.80"
           ]
           let outerCompletion: (([DecodableProtocol]) -> Void)? = {[weak self] (arr: [DecodableProtocol]) in
               self?.setModel(ds: arr, didLoadedFrom: .networkFirst)
               completion?()
           }
           AlamofireNetworkManager.request(clazz: MyGroup.self, urlPath: urlPath, params: params, completion: outerCompletion)
    }
    
    func getIndexPath() -> IndexPath {
        let rowIndex = sortedDataSource.count - 1
        return IndexPath(row: rowIndex, section: 0)
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

