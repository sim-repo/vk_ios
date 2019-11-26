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
}
