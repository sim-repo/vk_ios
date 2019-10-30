import Foundation
import Alamofire
import SwiftyJSON

class AlamofireNetworkManager{

    static let baseURL = "https://api.vk.com/method/"

    public static let sharedManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        config.timeoutIntervalForResource = 40
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()


    public static func requestItems<T: DecodableProtocol>(clazz: T.Type , urlPath: String, params: Parameters, completion: (([T])->Void)? = nil ){

        AlamofireNetworkManager.sharedManager.request(baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
            case .success(let val):
                BKG_THREAD {
                    let arr:[T]? = parseJsonItems(val)
                    if let arr = arr {
                        completion?(arr)
                    }
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    
    public static func wallRequest(urlPath: String, params: Parameters, completion: (([Wall])->Void)? = nil ){

        AlamofireNetworkManager.sharedManager.request(baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
            case .success(let val):
                BKG_THREAD {
                    let arr:[Wall]? = WallParser.parseWallJson(val)
                    if let arr = arr {
                        completion?(arr)
                    }
                }
            case .failure(let err):
                print(err)
            }
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

