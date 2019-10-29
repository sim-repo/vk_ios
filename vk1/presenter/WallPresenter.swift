import Foundation
import Alamofire

public class WallPresenter: PlainBasePresenter {
    
    let urlPath: String = "wall.get"
    
    override func loadFromNetwork(completion: (()->Void)? = nil){
        let params: Parameters = [
        "access_token": Session.shared.token,
        "extended": "1",
        "fields":["photo_50","photo_100", "photo_200"],
        "v": "5.103"
        ]
        let outerCompletion: (([DecodableProtocol]) -> Void)? = {[weak self] (arr: [DecodableProtocol]) in
            self?.setModel(ds: arr, didLoadedFrom: .networkFirst)
            completion?()
        }
        AlamofireNetworkManager.wallRequest(urlPath: urlPath, params: params, completion: outerCompletion)
    }

}


