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
    
    func checkToken(token: String, _ onChecked: ((Bool)->Void)?) {
        let presenter = PresenterFactory.shared.getInstance(clazz: LoginPresenter.self)
        let (onSuccess, onError) = getCompletions(presenter: presenter, nil)
        ApiVKService.checkVkTokenRequest(token: token, onSuccess, onError, onChecked)
    }
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
    }
}

