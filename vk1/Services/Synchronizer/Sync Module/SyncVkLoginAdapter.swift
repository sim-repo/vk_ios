import UIKit
import WebKit

// #adapter
class SyncVkLoginAdapter: SyncBaseProtocol {
    
    static let shared = SyncVkLoginAdapter()
    private override init() {}
    
    public func getId() -> String {
        return ModuleEnum.login.rawValue
    }
    
    func auth(webview: WKWebView) {
        ApiVKService.authVkRequest(webview: webview)
    }
    
    func checkToken(token: String, _ onChecked: ((Bool)->Void)?) {
        let presenter = PresenterFactory.shared.getInstance(clazz: LoginPresenter.self) // #adapter : КЛИЕНТ
        let (onSuccess, onError) = getCompletions(presenter: presenter, nil) // #adapter : КЛИЕНТСКИЙ CLOSURE
        ApiVKService.checkVkTokenRequest(token: token, onSuccess, onError, onChecked) // #adapter : ВЫЗОВ СЕРВИСА
    }
    
    func sync(_ dispatchCompletion: (()->Void)? = nil) {
    }
}

