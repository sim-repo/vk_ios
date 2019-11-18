import Foundation
import Alamofire
import SwiftyJSON

class AlamofireNetworkManager{


    public static let sharedManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        config.timeoutIntervalForResource = 40
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    
    public static func requestItems<T: DecodableProtocol>(clazz: T.Type ,
                                                             _ urlPath: String,
                                                             _ params: Parameters,
                                                             _ onSuccess: @escaping onSuccess_PresenterCompletion,
                                                             _ onError: @escaping  onErrResponse_SyncCompletion ) {
        
           AlamofireNetworkManager.sharedManager.request(baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
               switch response.result {
               case .success(let val):
                   BKG_THREAD {
                       let arr:[T]? = parseJsonItems(val)
                       if let arr = arr {
                           onSuccess(arr)
                       }
                   }
               case .failure(let err):
                    let error = err as NSError
                    onError(error)
               }
           }
    }
    
    
    public static func requestSingle<T: DecodableProtocol>(clazz: T.Type ,
                                                             _ urlPath: String,
                                                             _ params: Parameters,
                                                             _ onSuccess: @escaping onSuccess_PresenterCompletion,
                                                             _ onError: @escaping  onErrResponse_SyncCompletion ) {
           console(msg: "AlamofireNetworkManager: requestSingle(): start..")
           AlamofireNetworkManager.sharedManager.request(baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
               console(msg: "AlamofireNetworkManager: requestSingle(): response..")
               switch response.result {
               case .success(let json):
                   BKG_THREAD {
                        if let t: T = parseJson(json) {
                           var arr: [T] = []
                           arr.append(t)
                            DELAY_THREAD {
                                onSuccess(arr)
                            }
                        }
                        else {
                            let err = NSError(domain: "AlamofireNetworkManager: requestSingle(): response data is null : \(json)", code: 123, userInfo: nil)
                            onError(err)
                        }
                   }
               case .failure(let err):
                    let error = err as NSError
                    onError(error)
               }
           }
    }
    
    
    
    
    public static func wallRequest(_ urlPath: String,
                                   _ params: Parameters,
                                   _ onSuccess: @escaping onSuccess_PresenterCompletion,
                                   _ onError: @escaping  onErrResponse_SyncCompletion ){

        AlamofireNetworkManager.sharedManager.request(baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
            case .success(let json):
                BKG_THREAD {
                    let arr:[Wall]? = WallParser.parseWallJson(json)
                   
                    if let arr = arr {
                        if arr.isEmpty {
                            //let err = NSError(domain: "AlamofireNetworkManager: wallRequest(): response data is null : \(json)", code: 123, userInfo: nil)
                            let err = NSError(domain: "AlamofireNetworkManager: wallRequest(): response data is null", code: 123, userInfo: nil)
                            onError(err)
                        } else {
                            LDELAY_THREAD {
                                onSuccess(arr)
                            }
                        }
                    }
                }
            case .failure(let err):
                let error = err as NSError
                onError(error)
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
    
    
    private static func parseJson<T: DecodableProtocol>(_ val: Any)->T?{
        var res: T?
        let json = JSON(val)
        let items = json["response"].arrayValue
        
        for j in items {
            res = T()
            res?.setup(json: j)
        }
        return res
    }
    
}

