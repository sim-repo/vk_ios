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
    
    typealias Completion = (() -> Void)?
       
    private static var task1: Completion?
   
    private static func runRequest(task: Completion = nil){
        task?()
    }
    
    private static var count = 0
    static func tryAgain(task: Completion){
        
        let period = 300
        count += 1
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(period), qos: .userInteractive) {
            task?()
        }
    }
    
    
    
    
    public static func log(_ msg: String) {
        console(msg: msg, printEnum: .alamofire)
    }
    
    
    public static func requestItems<T: DecodableProtocol>(clazz: T.Type ,
                                                             _ urlPath: String,
                                                             _ params: Parameters,
                                                             _ onSuccess: @escaping onSuccess_PresenterCompletion,
                                                             _ onError: @escaping  onErrResponse_SyncCompletion ) {
        
           AlamofireNetworkManager.sharedManager.request(Network.baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
               switch response.result {
               case .success(let json):
                   let arr:[T]? = parseJsonItems(json)
                   if let arr = arr {
                        if arr.isEmpty {
                            let err = NSError(domain: "AlamofireNetworkManager: requestItems(): response data is null \(json)", code: 123, userInfo: nil)
                            onError(err)
                        } else {
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
           log("AlamofireNetworkManager: requestSingle(): start..")
           AlamofireNetworkManager.sharedManager.request(Network.baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
               log("AlamofireNetworkManager: requestSingle(): response..")
               switch response.result {
               case .success(let json):
                  if let t: T = parseJson(json) {
                           var arr: [T] = []
                           arr.append(t)
                            NET_DELAY_THREAD {
                                onSuccess(arr)
                            }
                        }
                        else {
                            let err = NSError(domain: "AlamofireNetworkManager: requestSingle(): response data is null : \(json)", code: 123, userInfo: nil)
                            onError(err)
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
                                   _ onError: @escaping  onErrResponse_SyncCompletion,
                                   _ offsetCompletion: (()->Void)?,
                                   _ offset: Int
                                   ){
        task1 = {
            AlamofireNetworkManager.sharedManager.request(Network.baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
                switch response.result {
                case .success(let json):
                    let arr:[Wall]? = WallParser.parseWallJson(json, offset: offset)
                       
                    if let arr = arr {
                        if arr.isEmpty {
                            if count < 4 {
                                tryAgain(task: task1!)
                                return
                            }
                            count = 0
                           // let err = NSError(domain: "AlamofireNetworkManager: wallRequest(): response data is null : \(json)", code: 123, userInfo: nil)
                            let err = NSError(domain: "AlamofireNetworkManager: wallRequest(): response data is null", code: 123, userInfo: nil)
                            offsetCompletion?()
                            onError(err)
                        } else {
                            count = 0
                            NET_LDELAY_THREAD {
                                offsetCompletion?()
                                onSuccess(arr)
                            }
                        }
                    }
                case .failure(let err):
                    count = 0
                    let error = err as NSError
                    onError(error)
                }
            }
        }
        runRequest(task: task1!)
    }
    
    
    
    public static func newsRequest(_ urlPath: String,
                                   _ params: Parameters,
                                   _ ownOffset: Int,
                                   _ vkOffset: String,
                                   _ onSuccess: @escaping onSuccess_PresenterCompletion,
                                   _ onError: @escaping  onErrResponse_SyncCompletion,
                                   _ offsetCompletion: ((String)->Void)?
                                   ){

        AlamofireNetworkManager.sharedManager.request(Network.baseURL + urlPath, method: .get, parameters: params).responseJSON{ response in
            switch response.result {
            case .success(let json):
                let arr:[News]? = NewsParser.parseNewsJson(json, ownOffset, vkOffset)
                   
                if let arr = arr {
                    if arr.isEmpty {
                        let err = NSError(domain: "AlamofireNetworkManager: newsRequest(): response data is null", code: 123, userInfo: nil)
                        onError(err)
                    } else {
                        if let offset = NewsParser.parseNextOffset(json) {
                            offsetCompletion?(offset)
                        }
                        NET_LDELAY_THREAD {
                            onSuccess(arr)
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

