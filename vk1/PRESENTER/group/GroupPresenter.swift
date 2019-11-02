import Foundation
import Alamofire

public class GroupPresenter: SectionedBasePresenter {
    
    let urlPath: String = "groups.search"
    
    var groups: [Group]!
    
    func numberOfRowsInSection() -> Int {
        return groups.count
    }
    
    func getName(_ indexPath: IndexPath) -> String {
        return groups?[indexPath.row].name ?? ""
    }
    
    func getDesc(_ indexPath: IndexPath) -> String {
        return groups?[indexPath.row].desc ?? ""
    }
    
    func getIcon(_ indexPath: IndexPath) -> String {
        return groups?[indexPath.row].icon ?? ""
    }
    
    func getGroup(_ indexPath: IndexPath?) -> Group? {
        guard let idxPath = indexPath
            else {return nil}
        return groups[idxPath.row]
    }
}
