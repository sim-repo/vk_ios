import UIKit
import WebKit

class Login_ViewController: UIViewController {
    
    var webview: WKWebView?
    
    @IBOutlet weak var containterView: UIView!
    
    var presenter: PullPlainPresenterProtocol!
    
    enum SegueEnum: String {
        case segueFibSignUp = "segueFibSignUp"
        case segueFibSignIn = "segueFibSignIn"
        case segueMainApp = "segueMainApp"
    }
    
    enum ViewEnum: Int {
        case vk = 1000
        case signIn = 2000
        case register = 3000
    }
    
    var onSignIn: ((String, String) -> Void)?
    var onRegister: (() -> Void)?
    var onVkAuthCompletion: ((MyAuth.token, MyAuth.userId) -> Void)?
    
    override func viewDidLoad() {
       setupPresenter()
       presenter.viewDidLoad()
    }
    
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
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
    
    private func showVkAuth(completion: ((WKWebView) -> Void)?){
        
        webview = WKWebView()
        guard let webview_ = webview else { return}
        
        webview_.navigationDelegate = self
        containterView.addSubview(webview_)
        webview_.translatesAutoresizingMaskIntoConstraints = false
        webview_.topAnchor.constraint(equalTo: containterView.topAnchor).isActive = true
        webview_.bottomAnchor.constraint(equalTo: containterView.bottomAnchor).isActive = true
        webview_.leadingAnchor.constraint(equalTo: containterView.leadingAnchor).isActive = true
        webview_.trailingAnchor.constraint(equalTo: containterView.trailingAnchor).isActive = true
        webview_.tag = ViewEnum.vk.rawValue
       
        completion?(webview_)
    }
    
    private func showFirebaseSignIn(login: String, psw: String, signInCompletion: ((String, String) -> Void)?, signUpCompletion: (() -> Void)?){
        removeSubview(by: .vk)
        removeSubview(by: .register)
        let subview = Bundle.main.loadNibNamed("FirSignin_View", owner: self, options: nil)!.first as! FirSignin_View
        subview.frame = containterView.bounds
        subview.setup(login: login, psw: psw, signInCompletion: signInCompletion, signUpCompletion: signUpCompletion)
        containterView.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: containterView.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: containterView.bottomAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: containterView.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: containterView.trailingAnchor).isActive = true
        subview.tag = ViewEnum.signIn.rawValue
    }
    
    private func showFirebaseRegister(onRegister: ((String, String) -> Void)?,
                                      onCancel: (()->Void)? ){
        removeSubview(by: .signIn)
        let subview = Bundle.main.loadNibNamed("FirSignup_View", owner: self, options: nil)!.first as! FirSignup_View
        subview.frame = containterView.bounds
        subview.setup(onRegister: onRegister, onCancel: onCancel)
        containterView.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: containterView.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: containterView.bottomAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: containterView.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: containterView.trailingAnchor).isActive = true
        subview.tag = ViewEnum.register.rawValue
    }
    
    private func removeSubview(by tag: ViewEnum) {
        let subviews = containterView.subviews
        for subview in subviews {
            if subview.tag == tag.rawValue {
                subview.removeFromSuperview()
            }
        }
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
               // onVkAuthCompletion?("","")
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
            let userId = params["user_id"]
            else {
                decisionHandler(.cancel)
                onVkAuthCompletion?("","")
                return
        }
        decisionHandler(.cancel)
        onVkAuthCompletion?(token, "\(userId)")
    }
}

extension Login_ViewController: PushPlainViewProtocol {
    
    func viewReloadData(moduleEnum: ModuleEnum) {
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?) {
    }
    
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?) {
    }
}

extension Login_ViewController: PushLoginViewProtocol {
    
    
    func showVkFormAuthentication(completion: ((WKWebView) -> Void)?) {
        showVkAuth(completion: completion)
    }
    
    
    
    func showFirebaseFormAuthentication(login: MyAuth.login,
                                        psw: MyAuth.psw,
                                        onSignIn: ((MyAuth.login, MyAuth.psw) -> Void)?,
                                        onRegister: (() -> Void)?) {
        
        //remember for reuse ability
        self.onSignIn = onSignIn
        self.onRegister = onRegister
        showFirebaseSignIn(login: login, psw: psw, signInCompletion: onSignIn, signUpCompletion: onRegister)
    }
    
    
    
    func showFirebaseFormRegister(onRegister: ((MyAuth.login, MyAuth.psw) -> Void)?,
                                  onCancel: (()->Void)? ) {
        
        showFirebaseRegister(onRegister: onRegister, onCancel: onCancel)
    }
    
    
    func runPerformSegue(segueId: String) {
        performSegue(withIdentifier: segueId, sender: nil)
    }
    
    
    func back() {
        //reuse:
        showFirebaseSignIn(login: "", psw: "", signInCompletion: onSignIn, signUpCompletion: onRegister)
    }
    
    func setRunAfterVkAuthentication(onVkAuthCompletion: ((MyAuth.token, MyAuth.userId)->Void)?){
        self.onVkAuthCompletion = onVkAuthCompletion
    }
}
