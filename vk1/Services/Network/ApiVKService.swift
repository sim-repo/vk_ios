import UIKit
import Alamofire
import WebKit

class ApiVKService {
    
    
    static func friendRequest(onSuccess: @escaping onSuccess_PresenterCompletion, onError: @escaping onErrResponse_SyncCompletion) {
        
        let urlPath: String = "friends.get"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "extended": "1",
            "fields":["bdate","sex","photo_50","photo_200_orig"],
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.requestItems(clazz: Friend.self, urlPath, params, onSuccess, onError)
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
            "filters": "all",
            "count": "\(count)",
            "offset": "\(offset)",
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.wallRequest(urlPath, params, onSuccess, onError, offsetCompletion, offset)
    }
    
    
    
    static func myGroupRequest(onSuccess: @escaping onSuccess_PresenterCompletion, onError: @escaping onErrResponse_SyncCompletion) {
        
        let urlPath: String = "groups.get"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "extended": "1",
            "fields":["description","members_count","photo_50","photo_200","cover"],
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.requestItems(clazz: MyGroup.self, urlPath, params, onSuccess, onError)
    }
    
    
    static func detailGroupRequest(group_id: typeId, onSuccess: @escaping onSuccess_PresenterCompletion, onError: @escaping onErrResponse_SyncCompletion) {
        
        let urlPath: String = "groups.getById"
        
        let params: Parameters = [
            "group_id": group_id,
            "access_token": Session.shared.token,
            "extended": "1",
            "fields":["counters","cover"],
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.requestSingle(clazz: DetailGroup.self, urlPath, params, onSuccess, onError)
    }
    
    
    static func groupRequest(txtSearch: String, onSuccess: @escaping onSuccess_PresenterCompletion, onError: @escaping onErrResponse_SyncCompletion) {
        
        let urlPath: String = "groups.search"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "q": txtSearch,
            "count": 10,
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.requestItems(clazz: Group.self, urlPath, params, onSuccess, onError)
    }
    
    static func groupJoinRequest(groupId: String) {
        
        let urlPath: String = "groups.join"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "group_id": groupId,
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.requestJoinGroup(clazz: Group.self, urlPath, params)
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
            "filters": "all",
            "offset": "\(offset)",
            "count": "1",
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.wallRequest(urlPath, params, onSuccess, onError, offsetCompletion, offset)
        
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
            "filters": ["post"],
            "count": count,
            "start_from": vkOffset,
            "v": NetworkConstant.shared.versionAPI
        ]
        if sinceTime != nil &&  sinceTime != 0 {
            params["start_time"] = sinceTime
        }
        
        AlamofireService.newsRequest(urlPath,
                                     params,
                                     ownOffset,
                                     vkOffset,
                                     onSuccess,
                                     onError,
                                     offsetCompletion
        )
    }
    
    
    static func videoRequest(postId: Int,
                             ownerId: Int,
                             _ onSuccess: ((URL, WallCellConstant.VideoPlatform)->Void)?,
                             _ onError: ((String)->Void)? ) {
        
        let urlPath: String = "video.get"
        
        let videoId = "\(ownerId)_\(postId)"
        let params: Parameters = [
            "videos":videoId,
            "count":"1",
            "extended":"1",
            "access_token": Session.shared.token,
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.videoRequest(urlPath, params, onSuccess, onError)
    }
    
    
    
    static func videoSearchRequest(q: String,
                                   _ onSuccess: ((URL, WallCellConstant.VideoPlatform)->Void)?,
                                   _ onError: ((String)->Void)?) {
        
        let urlPath: String = "video.search"
        
        let params: Parameters = [
            "q":q,
            "count":"1",
            "access_token": Session.shared.token,
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.videoRequest(urlPath, params, onSuccess, onError)
    }
    
    
    static func commentRequest(postId: Int,
                               ownerId: Int,
                               _ onSuccess: @escaping onSuccess_PresenterCompletion,
                               _ onError: @escaping onErrResponse_SyncCompletion ) {
        
        let urlPath: String = "wall.getComments"
        print("ownerId: \(ownerId) postId: \(postId)")
        let params: Parameters = [
            "owner_id": ownerId,
            "post_id": postId,
            "access_token": Session.shared.token,
            "extended": "1",
            "sort":"asc",
            "count": "100",
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.commentRequest(urlPath, params, onSuccess, onError)
    }
    
    
    static func likesRequest(itemId: Int,
                            _ ownerId: Int,
                            _ type: Like.LikeType,
                            _ onSuccess: @escaping onSuccess_PresenterCompletion,
                            _ onError: @escaping onErrResponse_SyncCompletion ) {
        
        let urlPath: String = "likes.getList"
        let params: Parameters = [
            "type": type.rawValue,
            "owner_id": ownerId,
            "item_id": itemId,
            "access_token": Session.shared.token,
            "extended": "1",
            "count": "100",
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.likesRequest(itemId, ownerId, type, urlPath, params, onSuccess, onError)
    }
    
    
    static func usersRequest(likes: [Like],
                             userIds: [Int],
                             fields: [String],
                             _ onSuccess: @escaping onSuccess_PresenterCompletion,
                             _ onError: @escaping onErrResponse_SyncCompletion ) {
        
        let urlPath: String = "users.get"
        let params: Parameters = [
            "user_ids": userIds,
            "fields": fields,
            "access_token": Session.shared.token,
            "extended": "1",
            "count": "100",
            "v": NetworkConstant.shared.versionAPI
        ]
        AlamofireService.usersRequest(likes: likes, urlPath, params, onSuccess, onError)
    }
    
    
    
    static func authVkRequest(webview: WKWebView) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: NetworkConstant.shared.clientId),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "wall,friends,groups,video,offline"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.87")
        ]
        let request = URLRequest(url: urlComponents.url!)
        webview.load(request)
    }
    
    
    
    static func checkVkTokenRequest(token: String,
                                    _ onSuccess: @escaping onSuccess_PresenterCompletion,
                                    _ onError: @escaping onErrResponse_SyncCompletion,
                                    _ onChecked: ((Bool)->Void)?
    ) {
        
        let urlPath: String = "secure.checkToken"
        
        let params: Parameters = [
            "token": token,
            "client_id": NetworkConstant.shared.clientId,
            "client_secret": NetworkConstant.shared.clientSecret,
            "v": NetworkConstant.shared.versionAPI
        ]
        
        AlamofireService.checkVkTokenRequest(urlPath, params, onSuccess, onError, onChecked)
    }
    
}
