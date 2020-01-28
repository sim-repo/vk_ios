import Foundation
import PromiseKit
import SwiftyJSON

//lesson 4: Promises
class NetworkPromiseRequest {
    
    private init(){}
    public static var shared = NetworkPromiseRequest()
    
    static let scheme = "https"
    static let host = "api.vk.com"

    
    
    public static func imageRequest(_ url: URL) -> Promise<UIImage?> {
        return firstly {
            URLSession.shared.dataTask(.promise, with: url)
        }.map { data, _ in
            return UIImage(data: data)
        }
    }
    
    
    public static func friendRequest (_ urlPath: String,
                                      _ onSuccess: @escaping onSuccess_PresenterCompletion,
                                      _ onError: @escaping  onErrResponse_SyncCompletion ) {
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/method/\(urlPath)"
        components.queryItems = [
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "bdate"),
            URLQueryItem(name: "fields", value: "sex"),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "fields", value: "photo_200_orig"),
            URLQueryItem(name: "v", value: NetworkConstant.shared.versionAPI)]
        
        let url = components.url!
        
        firstly {
            URLSession.shared.dataTask(.promise, with: url)
        }.done { (data, response) in
            let arr:[Friend]? = NetworkPromiseRequest.parseJsonItems(data)
            if let arr = arr {
                 if arr.isEmpty {
                     let err = NSError(domain: "NetworkPromiseRequest: requestItems(): response data is null \(data)", code: 123, userInfo: nil)
                     onError(err)
                 } else {
                     onSuccess(arr)
                 }
            }
        }.catch { error in
            let err = error as NSError
            onError(err)
        }
    }
    

    private static func parseJsonItems<T: DecodableProtocol>(_ val: Any)->[T]?{
        let json = JSON(val)
        var res: [T] = []
        let items = json["response"]["items"].arrayValue
        for j in items {
            let t: T = T()
            t.setup(json: j)
            res.append(t)
        }
        return res
    }
}
