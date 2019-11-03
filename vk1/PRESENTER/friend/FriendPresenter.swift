import Foundation
import Alamofire

class FriendPresenter: SectionPresenterProtocols {
    
    var modelClass: AnyClass  {
        return Friend.self
    }
    
    
    func onPerfomSegue_Details(selected indexPath: IndexPath) {
         guard let friend = getData(indexPath: indexPath) as? Friend
             else {
                 catchError(msg: "FriendPresenter: onPerfomSegue_Details")
                 return
             }
         let friendWallPresenter: FriendWallPresenter? = PresenterFactory.shared.getInstance()
         friendWallPresenter?.setFriend(friend: friend)
     }
}
