import UIKit
import Alamofire

class ApiVK {
    
    
    static func friendRequest(onSuccess: @escaping onSuccessPresenterCompletion, onError: @escaping onErrSyncCompletion) {
        
        let urlPath: String = "friends.get"
        
        let params: Parameters = [
              "access_token": Session.shared.token,
                  "extended": "1",
                  "fields":["bdate","sex","photo_50","photo_200_orig"],
            "v": versionAPI
        ]
        AlamofireNetworkManager.requestItems2(clazz: Friend.self, urlPath, params, onSuccess, onError)
    }
    
    
    static func myGroupRequest(onSuccess: @escaping onSuccessPresenterCompletion, onError: @escaping onErrSyncCompletion) {
        
        let urlPath: String = "groups.get"
        
        let params: Parameters = [
              "access_token": Session.shared.token,
                  "extended": "1",
                  "fields":["description","members_count","photo_50","photo_200","cover"],
            "v": versionAPI
        ]
        AlamofireNetworkManager.requestItems2(clazz: MyGroup.self, urlPath, params, onSuccess, onError)
    }
    
    
    static func detailGroupRequest(group_id: Int, onSuccess: @escaping onSuccessPresenterCompletion, onError: @escaping onErrSyncCompletion) {
        
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
    
    
    
    static func wallRequest(ownerId: Int, onSuccess: @escaping onSuccessPresenterCompletion, onError: @escaping onErrSyncCompletion) {

        let urlPath: String = "wall.get"
        
        let params: Parameters = [
                 "owner_id": ownerId,
                 "access_token": Session.shared.token,
                 "extended": "1",
                 "fields":["photo_50","photo_100", "photo_200"],
                 "filter": "all",
                 "count": "5",
                 "v": versionAPI
        ]
        AlamofireNetworkManager.wallRequest(urlPath, params, onSuccess, onError)
        
    }
      
}
