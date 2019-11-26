import UIKit
import WebKit

class SyncVkLogin: SyncBaseProtocol {
    
    static let shared = SyncVkLogin()
    private override init() {}
    
    public func getId() -> String {
        return ModuleEnum.login.rawValue
    }
    
    func auth(webview: WKWebView) {
        ApiVKService.authVkRequest(webview: webview)
    }
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
    }
}

