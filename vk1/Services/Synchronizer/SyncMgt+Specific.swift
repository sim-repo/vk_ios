import UIKit
import WebKit

extension SyncMgt {
    
    public func doFilter(filter: String, moduleEnum: ModuleEnum){
        switch moduleEnum {
        case .group:
            SyncGroup.shared.search(filter: filter)
        default:
            log("doFilter(): no case \(moduleEnum)", level: .warning)
        }
    }
    
    public func doJoin(groupId: String) {
        SyncGroup.shared.join(groupId: groupId)
    }
    
    // auth module:
    public func doVkAuth(webview: WKWebView) {
        SyncVkLogin.shared.auth(webview: webview)
    }
    
    public func doCheckVkToken(token: String, _ onChecked: ((Bool)->Void)? ) {
        SyncVkLogin.shared.checkToken(token: token, onChecked )
    }
    
    public func doVideoGet(postId: Int, ownerId: Int, _ onSuccess: ((URL, WallCellConstant.VideoPlatform) -> Void)?, _ onError: ((String)->Void)? ) {
        SyncVideo.doVideoGet(postId: postId, ownerId: ownerId, onSuccess, onError)
    }
    
    public func doVideoSearch(q: String, _ onSuccess: ((URL, WallCellConstant.VideoPlatform) -> Void)?, _ onError: ((String)->Void)?) {
        SyncVideo.doVideoSearch(q: q, onSuccess, onError)
    }

}
