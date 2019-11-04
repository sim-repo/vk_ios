import Foundation
import Alamofire

class MyGroupPresenter: SectionPresenterProtocols {

    // implements ModelOwnerProtocol
    var modelClass: AnyClass  {
        return MyGroup.self
    }
    
    
    override func viewDidSeguePrepare(segueId: String, indexPath: IndexPath) {
        guard let segue = SegueIdEnum(rawValue: segueId),
            segue == .detailGroup
            else {
                catchError(msg: "MyGroupPresenter: viewDidSeguePrepare(): segueId is incorrected: \(segueId)")
                return
            }
        
        guard let group = getData(indexPath: indexPath) as? MyGroup
                    else {
                        catchError(msg: "MyGroupPresenter: viewDidSeguePrepare(): no data with indexPath: \(indexPath)")
                        return
                    }
        
        guard let detailPresenter = PresenterFactory.shared.getInstance(clazz: MyGroupDetailPresenter.self) as? DetailPresenterProtocol
        else {
            catchError(msg: "MyGroupPresenter: viewDidSeguePrepare(): detailPresenter is not conformed DetailPresenterProtocol")
            return
        }
        detailPresenter.setDetailModel(model: group)
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
