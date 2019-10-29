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
                    let arr:[Wall]? = parseWallJson(val)
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
    
    private static func parseWallJson(_ val: Any)->[Wall]?{
        let json = JSON(val)
        var res: [Wall] = []
        let items = json["response"]["items"].arrayValue
        let jsonProfiles = json["response"]["profiles"].arrayValue
        let jsonGroups = json["response"]["groups"].arrayValue
        let dicGroups = parseGroup(jsonGroups)
        let dicFriends = parseFriend(jsonProfiles)
        for j in items {
            let w = Wall()
            w.setup(json: j, friends: dicFriends, groups: dicGroups)
            res.append(w)
        }
        return res
    }
    
    private static func parseFriend(_ profiles: [JSON]) -> [Int:Friend]{
        var res: [Int:Friend] = [:]
        for json in profiles {
            let friend = Friend()
            friend.setupFromWall(json: json)
            res[friend.getId()] = friend
        }
        return res
    }
    
    private static func parseGroup(_ groups: [JSON]) -> [Int:Group]{
        var res: [Int:Group] = [:]
        for json in groups {
            let group = Group()
            group.setupFromWall(json: json)
            res[group.getId()] = group
        }
        return res
    }
}

