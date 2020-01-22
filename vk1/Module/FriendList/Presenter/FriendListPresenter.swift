import Foundation

class FriendListPresenter: SectionedBasePresenter, ModulablePresenterProtocol, SyncablePresenterParametersProtocol {
    var module: ModuleEnum = .friendList
    
    var modelClass: ModelProtocol.Type {
        return Friend.self
    }
    var isViewReloadWhenNetFinish = true
}

extension FriendListPresenter: ViewableFriendListPresenterProtocol {
    func viewDidFilterInput(_ filterText: String) {
        self.filteredText = !filterText.isEmpty ? filterText : nil
        filterAndRegroupData()
        getView()?.viewReloadData(groupByIds: self.groupByIds)
    }
}
