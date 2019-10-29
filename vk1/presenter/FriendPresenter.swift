import Foundation
import Alamofire

public class FriendPresenter: SectionedBasePresenter{
    
    let urlPath: String = "friends.get"

    override func loadFromNetwork(completion: (()->Void)? = nil){
        let params: Parameters = [
        "access_token": Session.shared.token,
        "extended": "1",
        "fields":["bdate","sex","photo_50","photo_200_orig"],
        "v": "5.80"
        ]
        let outerCompletion: (([DecodableProtocol]) -> Void)? = {[weak self] (arr: [DecodableProtocol]) in
            self?.setModel(ds: arr, didLoadedFrom: .networkFirst)
            completion?()
        }
        AlamofireNetworkManager.request(clazz: Friend.self, urlPath: urlPath, params: params, completion: outerCompletion)
    }
}

