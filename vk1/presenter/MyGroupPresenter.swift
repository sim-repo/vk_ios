import Foundation

public class MyGroupPresenter: BasePresenter{
    
    var groups: [MyGroup]!
    
    override func initDataSource(){
        groups = MyGroup.list()
    }
    
    func getData(_ indexPath: IndexPath) -> MyGroup? {
        return groups?[indexPath.row] 
    }
    
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
