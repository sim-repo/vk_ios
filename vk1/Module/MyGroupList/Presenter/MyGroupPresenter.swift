import Foundation

class MyGroupPresenter: SectionedBasePresenter {

    var netFinishViewReload: Bool = true
    
    var module: ModuleEnum  = .myGroupList
    
    // implements ModelOwnerProtocol
    var modelClass: ModelProtocol.Type  {
        return MyGroup.self
    }
    
    var coordinator: PresentableCoordinatorProtocol?
    
    
    func addGroup(group: Group) -> Bool {
        let has = dataSource.contains {$0.getId() == group.id}
        guard !has
            else { return false }
        appendDataSource(dirtyData: [group], didLoadedFrom: .network)
        return true
    }
    
    func removeGroup(indexPath: IndexPath) {
        dataSource.remove(at: indexPath.row)
    }
}

extension MyGroupPresenter: ModulablePresenterProtocol {}

extension MyGroupPresenter: ViewableTransitionPresenterProtocol {
    
    func didPressTransition(to module: ModuleEnum, selectedIndexPath: IndexPath) {
        
        guard let myGroup = getData(indexPath: selectedIndexPath) as? MyGroup
        else {
            Logger.catchError(msg: "MyGroupPresenter(): didPressTransition(): selectImage: getData exception ")
            return
        }
        coordinator?.didPressTransition(to: module, model: myGroup)
    }
    
    func didPressBack() {
        coordinator?.didPressBack()
    }
}

