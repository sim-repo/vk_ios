import Foundation

class MyGroupListPresenter: SectionedBasePresenter {

    var isViewReloadWhenNetFinish = true
    
    var module: ModuleEnum  = .myGroupList
    
    // implements ModelOwnerProtocol
    var modelClass: ModelProtocol.Type  {
        return MyGroup.self
    }
    
    override func didSetContext() {
      //  synchronizer?.tryRunSync()
    }
    
    // specific func:
    
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

extension MyGroupListPresenter: ModulablePresenterProtocol {}

extension MyGroupListPresenter: ViewableTransitionPresenterProtocol {
    
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

extension MyGroupListPresenter: SyncablePresenterParametersProtocol {}

extension MyGroupListPresenter: GroupablePresenterProtocol, SortablePresenterProtocol {
    
    func sort() {
           let ds = dataSource as! [MyGroup]
           dataSource = ds.sorted {
               $0.name > $1.name
           }
       }

    
    func groupBy(model: ModelProtocol) -> String {
        (model as! MyGroup).name
    }
}

