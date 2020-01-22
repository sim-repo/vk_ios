import Foundation


class LoginPresenter : ViewableLoginPresenterProtocol {

    var synchronizer: PresentableLoginSyncProtocol?
    var view: PresentableLoginViewProtocol?
    var coordinator: LoginCoordinator?
    
    
    required init(coordinator: LoginCoordinator, synchronizer: PresentableLoginSyncProtocol) {
        self.coordinator = coordinator
        self.synchronizer = synchronizer
    }
    
    
    func viewDidLoad() {
        guard let view = view
        else {
            log("viewDidLoad(): view is nil", level: .error)
            return
        }
        
        view.setRunAfterVkAuthentication(onVkAuthCompletion: { [weak self] (token, userId) in
            self?.log("setRunAfterVkAuthentication()", level: .info)
            RealmService.saveVKCredentials(token, userId)
            Session.shared.set(token, userId)
            self?.checkFirebaseCredentials(view: view)
        })
        
        
        checkVKCredentials(
            onSuccess: { [weak self] in
                self?.log("checkVKCredentials(): checked success", level: .info)
                self?.checkFirebaseCredentials(view: view)
            },
            onError: { [weak self] in
                self?.log("checkVKCredentials(): checked failed", level: .info)
                view.showVkFormAuthentication() {  (webview) in
                    self?.log("checkVKCredentials(): showVkFormAuthentication()", level: .info)
                    self?.synchronizer?.tryAuth(webview: webview)
                }
            })
    }
    
    
    private func checkVKCredentials(onSuccess: (()->Void)?, onError: (()->Void)?) {
        if let (t,u) = RealmService.loadToken(),
            let token = t,
            let userId = u {
                log("checkVKCredentials(): loadToken(): success", level: .info)
                let onChecked: ((Bool)->Void)? = { (checked) in
                    if checked {
                        Session.shared.token = token
                        Session.shared.userId = userId
                        onSuccess?()
                    } else {
                        onError?()
                    }
                }
                synchronizer?.tryCheckToken(token: token, onChecked)
                return
            }
        onError?()
    }
    
    private func checkFirebaseCredentials(view: PresentableLoginViewProtocol) {
        let (login, psw) = self.loadFirebaseCredentials()
        view.showFirebaseFormAuthentication(login: login,
                                            psw: psw,
                                            onSignIn: { [weak self] (login, psw) in
                                                self?.log("runFirebaseAuthentication(): onSignIn()", level: .info)
                                                self?.firebaseSignIn(login, psw)
                                            },
                                            onRegister: { [weak self] in
                                                self?.log("runFirebaseAuthentication(): onRegister()", level: .info)
                                                view.showFirebaseFormRegister(
                                                    onRegister: { [weak self] (login, psw) in
                                                        self?.log("showFirebaseFormRegister(): onRegister()", level: .info)
                                                        self?.firebaseRegister(login, psw)
                                                    },
                                                    onCancel: {  [weak self] in
                                                        self?.log("showFirebaseFormRegister(): onCancel()", level: .info)
                                                        view.back()
                                                    })
                                            })
    }
    
    
    private func loadFirebaseCredentials() -> (MyAuth.login, MyAuth.psw) {
        if let (login, psw) = RealmService.loadFirebaseCredentials(),
        let login_ = login, let psw_ = psw {
            return (login_, psw_)
        }
        return ("", "")
    }
    
    
    private func firebaseRegister(_ login: MyAuth.login, _ psw: MyAuth.psw){
        FirebaseService.shared.signUp(login: login,
                                        psw: psw,
                                        onSuccess: { [weak self] (login, psw) in
                                          self?.log("FirebaseService(): register(): onSuccess()", level: .info)
                                          RealmService.saveFirebaseCredentials(login, psw)
                                          self?.coordinator?.didPressTransition()
                                        },
                                        onError: { [weak self] (err) in
                                          self?.log("FirebaseService(): register(): onError(): \(err)", level: .error)
                                        })
    }
    
    
    private func firebaseSignIn(_ login: MyAuth.login, _ psw: MyAuth.psw) {
        FirebaseService.shared.signIn(login: login,
                                        psw: psw,
                                        onSuccess: { [weak self] in
                                            self?.log("FirebaseService(): signIn(): onSuccess()", level: .info)
                                            RealmService.saveFirebaseCredentials(login, psw)
                                            self?.coordinator?.didPressTransition()
                                        },
                                        onError: { [weak self] (err) in
                                          self?.log("FirebaseService(): signIn(): onError(): \(err)", level: .error)
                                        })
    }
    
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "LoginPresenter", msg, level: level, printEnum: .presenterCallsFromView)
    }
}
