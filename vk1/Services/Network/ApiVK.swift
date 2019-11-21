import UIKit
import Alamofire

class ApiVK {
    
    
    static func friendRequest(onSuccess: @escaping onSuccess_PresenterCompletion, onError: @escaping onErrResponse_SyncCompletion) {
        
        let urlPath: String = "friends.get"
        
        let params: Parameters = [
              "access_token": Session.shared.token,
                  "extended": "1",
                  "fields":["bdate","sex","photo_50","photo_200_orig"],
            "v": versionAPI
        ]
        AlamofireNetworkManager.requestItems(clazz: Friend.self, urlPath, params, onSuccess, onError)
    }
    
    
    static func friendWallRequest(ownerId: typeId,
                                  offset: Int,
                                  count: Int,
                                  onSuccess: @escaping onSuccess_PresenterCompletion,
                                  onError: @escaping onErrResponse_SyncCompletion,
                                  offsetCompletion: (()->Void)?) {

        let urlPath: String = "wall.get"
        
        let params: Parameters = [
                 "owner_id": ownerId,
                 "access_token": Session.shared.token,
                 "extended": "1",
                 "fields":["photo_50","photo_100", "photo_200"],
                 "filter": "all",
                 "count": "\(count)",
                 "offset": "\(offset)",
                 "v": versionAPI
        ]
        AlamofireNetworkManager.wallRequest(urlPath, params, onSuccess, onError, offsetCompletion, offset)
    }
      
    
    
    static func myGroupRequest(onSuccess: @escaping onSuccess_PresenterCompletion, onError: @escaping onErrResponse_SyncCompletion) {
        
        let urlPath: String = "groups.get"
        
        let params: Parameters = [
              "access_token": Session.shared.token,
                  "extended": "1",
                  "fields":["description","members_count","photo_50","photo_200","cover"],
            "v": versionAPI
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
            "v": versionAPI
        ]
        AlamofireNetworkManager.requestSingle(clazz: DetailGroup.self, urlPath, params, onSuccess, onError)
    }
    
    
    static func wallRequest(ownerId: typeId,
                            onSuccess: @escaping onSuccess_PresenterCompletion,
                            onError: @escaping onErrResponse_SyncCompletion,
                            offsetCompletion: (()->Void)?,
                            offset: Int
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
                 "v": versionAPI
        ]
        AlamofireNetworkManager.wallRequest(urlPath, params, onSuccess, onError, offsetCompletion, offset)
        
    }
    
    
    static func newsRequest(_ offset: String,
                            _ count: Int,
                            onSuccess: @escaping onSuccess_PresenterCompletion,
                            onError: @escaping onErrResponse_SyncCompletion,
                            setNextOffsetCompletion: ((String)->Void)?) {
        
        let urlPath: String = "newsfeed.get"
        
        let params: Parameters = [
               // "start_time": getUnixTime(date: Date().dayBefore),
               // "end_time": getUnixTime(date: Date()),
                "access_token": Session.shared.token,
                "extended": "1",
               // "fields":["photo_50","photo_100", "photo_200"],
                "filter": "photo, wall_photo",
                "count": count,
                "start_from": offset,
                "v": versionAPI
        ]
        
        AlamofireNetworkManager.newsRequest(urlPath, params, onSuccess, onError, setNextOffsetCompletion)
    }
      
}
