import UIKit
import WebKit

class Login_ViewController: UIViewController {
    
    var webview: WKWebView?
    
    enum SegueEnum: String {
        case segueFibSignUp = "segueFibSignUp"
        case segueFibSignIn = "segueFibSignIn"
        case segueMainApp = "segueMainApp"
    }
    
    override func viewDidLoad() {
        if !loadVKCredentials() {
            runVkAuth() { [weak self] in
                guard let self = self else { return }
                if !self.loadFibCredentials() {
                    self.runFibAuth()
                }
            }
        }
    }
    
    private func loadVKCredentials() -> Bool {
        if let (t,u) = RealmService.loadToken(),
            let token = t,
            let userId = u {
            Session.shared.token = token
            Session.shared.userId = userId
            return true
        }
        return false
    }
    
    private func showVkAuth(completion: (()->Void)? = nil ){
        webview = WKWebView()
        guard let webview_ = webview else { return}
        
        webview_.navigationDelegate = self
        webview_.translatesAutoresizingMaskIntoConstraints = false
        webview_.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webview_.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webview_.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webview_.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.addSubview(webview_)
        completion?()
    }
    
    private func showFirSignIn(login: String, psw: String, completion: (()->Void)? = nil ){
        webview?.removeFromSuperview()
        let subview = Bundle.main.loadNibNamed("FirSignin_View", owner: self, options: nil)!.first as! FirSignin_View
        subview.frame = view.bounds
        subview.setup(login: login, psw: psw, completion: completion)
        view.addSubview(subview)
        subview.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func showFirSignUp(completion: completion: (()->Void)? = nil ){
        
    }
    
    private func loadFibCredentials() -> Bool {
        return false
    }
    
    private func runFibAuth(completion: (()->Void)? = nil) {
        print("run fib auth")
    }
}


extension Login_ViewController: WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
            else {
                decisionHandler(.allow)
                return
            }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        guard let token = params["access_token"],
            let userId = Int(params["user_id"]!)
            else {
                decisionHandler(.cancel)
                return
        }
        
        
        RealmService.saveVKCredentials(token: token, userId: userId)
        print(token, userId)
        Session.shared.token = token
        Session.shared.userId = userId
        performSegue(withIdentifier: "ShowMainSegue2", sender: nil)
        decisionHandler(.cancel)
    }
}


extension Login_ViewController: PushLoginViewProtocol {
    
    
    func showVkAuthentication(completion: (() -> Void)?) {
        showVkAuth(completion: completion)
    }
    
    
    func showFibAuthentication(login: String, psw: String, completion: (()->Void)?) {
        showFirSignIn(login: login, psw: psw, completion: completion)
    }
    
}
