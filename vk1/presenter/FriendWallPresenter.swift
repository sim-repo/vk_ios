import Foundation
import Alamofire

public class FriendWallPresenter: PlainBasePresenter{
    
    let urlPath: String = "wall.get"
      
    var friend: Friend?

    override func loadFromNetwork(completion: (()->Void)? = nil){
       let params: Parameters = [
       "access_token": Session.shared.token,
       "extended": "1",
       "v": "5.80"
       ]
       let outerCompletion: (([DecodableProtocol]) -> Void)? = {[weak self] (arr: [DecodableProtocol]) in
           self?.setModel(ds: arr, didLoadedFrom: .networkFirst)
           completion?()
       }
       AlamofireNetworkManager.request(clazz: Wall.self, urlPath: urlPath, params: params, completion: outerCompletion)
    }
    
    func setFriend(friend: Friend) {
        self.friend = friend
    }
}
