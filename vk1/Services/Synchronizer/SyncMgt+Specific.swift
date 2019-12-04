import UIKit
import WebKit

extension SyncMgt {
    
    public func doFilter(filter: String, moduleEnum: ModuleEnum){
        switch moduleEnum {
        case .group:
            SyncGroup.shared.search(filter: filter)
        default:
            log("doFilter(): no case \(moduleEnum)", isErr: true)
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
    
    public func doVideoGet(postId: Int, ownerId: Int, completion: ((URL, WallCellConstant.VideoPlatform)->Void)?) {
        SyncVideo.doVideoGet(postId: postId, ownerId: ownerId, completion: completion)
    }
    
    public func doVideoSearch(q: String, completion: ((URL, WallCellConstant.VideoPlatform) -> Void)?) {
        SyncVideo.doVideoSearch(q: q, completion: completion)
    }

}
