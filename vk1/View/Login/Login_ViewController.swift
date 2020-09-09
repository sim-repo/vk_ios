import UIKit
import WebKit

class Login_ViewController: UIViewController {
    
    var webview: WKWebView?
    
    @IBOutlet weak var containterView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var bottomInsetView: UIView!
    
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    var presenter: PullPlainPresenterProtocol!
    
    enum ViewEnum: Int {
        case vk = 1000
        case signIn = 2000
        case register = 3000
    }
    
    
    var vkShownNow = false
    var onSignIn: ((String, String) -> Void)?
    var onRegister: (() -> Void)?
    var onVkAuthCompletion: ((MyAuth.token, MyAuth.userId) -> Void)?
    
    override func viewDidLoad() {
        containterView.backgroundColor = ColorSystemHelper.clearColor
        setupPresenter()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        runLogo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
    }
    
    
    private func runLogo() {
        let w: CGFloat = 232.0
        let logoAnimation = WaitIndicator2(frame: CGRect(x: wHalfScreen - w/2.0,
                                                         y: logoView.frame.height/3, width: wScreen, height: 100))
        logoAnimation.backgroundColor = ColorSystemHelper.clearColor
        logoView.backgroundColor = ColorSystemHelper.clearColor
        logoView.addSubview(logoAnimation)
    }
}



//MARK: - Main Login:
extension Login_ViewController {
    
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
        vkShownNow = true
        webview = WKWebView()
        guard let webview_ = webview else { return}
        
        webview_.navigationDelegate = self
        webview_.alpha = 0
        containterView.addSubview(webview_)
        removeSubview(by: .register, appeared: webview_)
        webview_.translatesAutoresizingMaskIntoConstraints = false
        webview_.topAnchor.constraint(equalTo: containterView.topAnchor).isActive = true
        webview_.bottomAnchor.constraint(equalTo: containterView.bottomAnchor).isActive = true
        webview_.leadingAnchor.constraint(equalTo: containterView.leadingAnchor).isActive = true
        webview_.trailingAnchor.constraint(equalTo: containterView.trailingAnchor).isActive = true
        webview_.scrollView.isScrollEnabled = true
        webview_.tag = ViewEnum.vk.rawValue
        
        completion?(webview_)
    }
    
    private func showFirebaseSignIn(login: String, psw: String, signInCompletion: ((String, String) -> Void)?, signUpCompletion: (() -> Void)?){
        vkShownNow = false
        let subview = Bundle.main.loadNibNamed("FirSignin_View", owner: self, options: nil)!.first as! FirSignin_View
        subview.frame = containterView.bounds
        subview.setup(login: login, psw: psw, signInCompletion: signInCompletion, signUpCompletion: signUpCompletion)
        
        subview.alpha = 0
        containterView.addSubview(subview)
        
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: containterView.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: containterView.bottomAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: containterView.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: containterView.trailingAnchor).isActive = true
        view.layoutIfNeeded()
        subview.tag = ViewEnum.signIn.rawValue
        removeSubview(by: .vk)
        removeSubview(by: .register, appeared: subview)
    }
    
    private func showFirebaseRegister(onRegister: ((String, String) -> Void)?,
                                      onCancel: (()->Void)? ){
        
        let subview = Bundle.main.loadNibNamed("FirSignup_View", owner: self, options: nil)!.first as! FirSignup_View
        subview.frame = containterView.bounds
        subview.setup(onRegister: onRegister, onCancel: onCancel)
        subview.alpha = 0
        containterView.addSubview(subview)
        
        removeSubview(by: .signIn, appeared: subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: containterView.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: containterView.bottomAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: containterView.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: containterView.trailingAnchor).isActive = true
        subview.tag = ViewEnum.register.rawValue
    }
    
    private func removeSubview(by tag: ViewEnum, appeared: UIView? = nil) {
        let subviews = containterView.subviews
        if let subview = subviews.first(where: {$0.tag == tag.rawValue}) {
            UIView.animate(withDuration: 0.8,
                           animations: { [weak self] in
                            subview.alpha = 0.0
                            self?.containterView.layoutIfNeeded()
                },
                           completion: {_ in
                            subview.removeFromSuperview()
                            appeared?.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.8,
                           animations: { [weak self] in
                            appeared?.alpha = 1
                            self?.containterView.layoutIfNeeded()
            })
        }
    }
}





//MARK: - Keyboard Actions:
extension Login_ViewController {
    
    @objc func keyboardWasShown(_ notification: NSNotification){
        let info = notification.userInfo! as NSDictionary
        let size = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        bottomHeightConstraint.constant = size.height-30
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWasHidden(){
        if vkShownNow {
          bottomHeightConstraint.constant = 0
          view.layoutIfNeeded()
        }
    }

}



//MARK: - WebView Delegate:

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


//MARK:- calls from presenter:

extension Login_ViewController: PushPlainViewProtocol {
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol? = nil) {
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: segueId, sender: nil)
        }
    }
    
    func runPerformSegue(segueId: String, _ indexPath: IndexPath) {}
    
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
    
    func back() {
        //reuse:
        showFirebaseSignIn(login: "", psw: "", signInCompletion: onSignIn, signUpCompletion: onRegister)
    }
    
    func setRunAfterVkAuthentication(onVkAuthCompletion: ((MyAuth.token, MyAuth.userId)->Void)?){
        self.onVkAuthCompletion = onVkAuthCompletion
    }
}
