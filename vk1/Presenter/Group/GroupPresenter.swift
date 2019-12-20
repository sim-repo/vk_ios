import Foundation
import Firebase

class GroupPresenter: PlainPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    var modelClass: AnyClass  {
        return Group.self
    }
    
    func joinGroup(groupId: String) {
        SyncMgt.shared.doJoin(groupId: groupId)
        fibAdd(groupId: groupId)
    }
    
    private func fibAdd(groupId: String){
        FirebaseService.shared.addGroup(groupId: groupId)
    }
}
