import Foundation
import Alamofire

class FriendPresenter: SectionPresenterProtocols {
    
    var modelClass: AnyClass  {
        return Friend.self
    }
    

    override func viewDidSeguePrepare(segueId: String, indexPath: IndexPath) {
        guard let segue = SegueIdEnum(rawValue: segueId),
                  segue == .detailFriend
            else {
                catchError(msg: "FriendPresenter: viewDidSeguePrepare(): segueId is incorrected: \(segueId)")
                return
            }
        
        guard let friend = getData(indexPath: indexPath) as? Friend
                    else {
                        catchError(msg: "FriendPresenter: viewDidSeguePrepare(): no data with indexPath: \(indexPath)")
                        return
                    }
        
        guard let detailPresenter = PresenterFactory.shared.getInstance(clazz: FriendWallPresenter.self) as? DetailPresenterProtocol
        else {
            catchError(msg: "FriendPresenter: viewDidSeguePrepare(): detailPresenter is not conformed DetailPresenterProtocol")
            return
        }
        detailPresenter.setDetailModel(model: friend)
    }
}
