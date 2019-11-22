import UIKit
import Alamofire

class ApiVK {
    
    
    static func friendRequest(onSuccess: @escaping onSuccess_PresenterCompletion, onError: @escaping onErrResponse_SyncCompletion) {
        
        let urlPath: String = "friends.get"
        
        let params: Parameters = [
              "access_token": Session.shared.token,
                  "extended": "1",
                  "fields":["bdate","sex","photo_50","photo_200_orig"],
                  "v": Network.versionAPI
        ]
        AlamofireNetworkManager.requestItems(clazz: Friend.self, urlPath, params, onSuccess, onError)
    }
    
    
    static func friendWallRequest(_ ownerId: typeId,
                                  _ offset: Int,
                                  _ count: Int,
                                  _ onSuccess: @escaping onSuccess_PresenterCompletion,
                                  _ onError: @escaping onErrResponse_SyncCompletion,
                                  _ offsetCompletion: (()->Void)?) {

        let urlPath: String = "wall.get"
        
        let params: Parameters = [
                 "owner_id": ownerId,
                 "access_token": Session.shared.token,
                 "extended": "1",
                 "fields":["photo_50","photo_100", "photo_200"],
                 "filter": "all",
                 "count": "\(count)",
                 "offset": "\(offset)",
                 "v": Network.versionAPI
        ]
        AlamofireNetworkManager.wallRequest(urlPath, params, onSuccess, onError, offsetCompletion, offset)
    }
      
    
    
    static func myGroupRequest(onSuccess: @escaping onSuccess_PresenterCompletion, onError: @escaping onErrResponse_SyncCompletion) {
        
        let urlPath: String = "groups.get"
        
        let params: Parameters = [
              "access_token": Session.shared.token,
                  "extended": "1",
                  "fields":["description","members_count","photo_50","photo_200","cover"],
            "v": Network.versionAPI
        ]
        AlamofireNetworkManager.requestItems(clazz: MyGroup.self, urlPath, params, onSuccess, onError)
    }
    
    
    static func detailGroupRequest(group_id: typeId, onSuccess: @escaping onSuccess_PresenterCompletion, onError: @escaping onErrResponse_SyncCompletion) {
        
        let urlPath: String = "groups.getById"
        
        let params: Parameters = [
            "group_id": group_id,
            "access_token": Session.shared.token,
            "extended": "1",
            "fields":["counters","cover"],
            "v": Network.versionAPI
        ]
        AlamofireNetworkManager.requestSingle(clazz: DetailGroup.self, urlPath, params, onSuccess, onError)
    }
    
    
    static func wallRequest(_ ownerId: typeId,
                            _ onSuccess: @escaping onSuccess_PresenterCompletion,
                            _ onError: @escaping onErrResponse_SyncCompletion,
                            _ offsetCompletion: (()->Void)?,
                            _ offset: Int
                            ) {

        let urlPath: String = "wall.get"
        
        let params: Parameters = [
                 "owner_id": ownerId,
                 "access_token": Session.shared.token,
                 "extended": "1",
                 "fields":["photo_50","photo_100", "photo_200"],
                 "filter": "all",
                 "offset": "\(offset)",
                 "count": "1",
                 "v": Network.versionAPI
        ]
        AlamofireNetworkManager.wallRequest(urlPath, params, onSuccess, onError, offsetCompletion, offset)
        
    }
    
    
    static func newsRequest(_ ownOffset: Int,
                            _ vkOffset: String,
                            _ count: Int,
                            _ onSuccess: @escaping onSuccess_PresenterCompletion,
                            _ onError: @escaping onErrResponse_SyncCompletion,
                            _ offsetCompletion: ((String)->Void)?,
                            _ sinceTime: Double? = nil
                            ) {
        
        let urlPath: String = "newsfeed.get"
        
        var params: Parameters = [
                "access_token": Session.shared.token,
                "extended": "1",
                "filter": "photo, wall_photo",
                "count": count,
                "start_from": vkOffset,
                "v": Network.versionAPI
        ]
        if sinceTime != nil &&  sinceTime != 0 {
            params["start_time"] = sinceTime
        }
        
        AlamofireNetworkManager.newsRequest(urlPath,
                                            params,
                                            ownOffset,
                                            vkOffset,
                                            onSuccess,
                                            onError,
                                            offsetCompletion
                                            )
    }
      
}
