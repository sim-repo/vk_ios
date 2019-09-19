import Foundation

public class MyGroupPresenter: BasePresenter{
    
    var groups: [MyGroup]!
    
    override func initDataSource(){
        groups = MyGroup.list()
    }
    
    func numberOfRowsInSection() -> Int {
        return groups.count
    }
    
    func getDesc(_ indexPath: IndexPath) -> String {
        return groups?[indexPath.row].name ?? ""
    }
    
    func getIcon(_ indexPath: IndexPath) -> String {
        return groups?[indexPath.row].icon ?? ""
    }
    
    func getIndexPath() -> IndexPath {
        let rowIndex = groups.count - 1
        return IndexPath(row: rowIndex, section: 0)
    }
    
    func addGroup(group: Group) -> Bool {
        let has = groups.contains {$0.id == group.id}
        guard !has
            else { return false }
        
        groups.append(MyGroup(group: group))
        return true
    }
    
    func removeGroup(indexPath: IndexPath) {
        groups.remove(at: indexPath.row)
    }
}
