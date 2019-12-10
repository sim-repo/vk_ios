import Foundation


class LoginPresenter: PlainPresenterProtocols {
    
    
    var netFinishViewReload: Bool = false
    
    
    var modelClass: AnyClass  {
        return Login.self
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        switch level {
        case .info:
            Logger.console(msg: "PlainBasePresenter: \(self.clazz): " + msg, printEnum: .login)
        case .warning:
            Logger.catchWarning(msg: "PlainBasePresenter: \(self.clazz): " + msg)
        case .error:
            Logger.catchError(msg: "PlainBasePresenter: \(self.clazz): " + msg)
        }
    }
}


// MARK: - authentication flow

extension LoginPresenter {
    
    override func viewDidLoad() {
        
        guard let view_ = view as? (PushLoginViewProtocol & PushViewProtocol)
        else {
            log("viewDidLoad(): conform protocol exception", level: .error)
            return
        }
        
        view_.setRunAfterVkAuthentication(onVkAuthCompletion: { [weak self] (token, userId) in
            self?.log("setRunAfterVkAuthentication()", level: .info)
            RealmService.saveVKCredentials(token, userId)
            Session.shared.set(token, userId)
            self?.checkFirebaseCredentials(view: view_)
        })
        
        
        checkVKCredentials(
            onSuccess: { [weak self] in
                self?.log("checkVKCredentials(): checked success", level: .info)
                self?.checkFirebaseCredentials(view: view_)
            },
            onError: { [weak self] in
                self?.log("checkVKCredentials(): checked failed", level: .info)
                view_.showVkFormAuthentication() {  (webview) in
                    self?.log("checkVKCredentials(): showVkFormAuthentication()", level: .info)
                    SyncMgt.shared.doVkAuth(webview: webview)
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
                SyncMgt.shared.doCheckVkToken(token: token, onChecked)
                return
            }
        onError?()
    }
    

    private func checkFirebaseCredentials(view: PushLoginViewProtocol&PushViewProtocol) {
        let (login, psw) = self.loadFirebaseCredentials()
        view.showFirebaseFormAuthentication(login: login,
                                            psw: psw,
                                            onSignIn: { [weak self] (login, psw) in
                                                self?.log("runFirebaseAuthentication(): onSignIn()", level: .info)
                                                self?.firebaseSignIn(view, login, psw)
                                            },
                                            onRegister: { [weak self] in
                                                self?.log("runFirebaseAuthentication(): onRegister()", level: .info)
                                                view.showFirebaseFormRegister(
                                                    onRegister: { [weak self] (login, psw) in
                                                        self?.log("showFirebaseFormRegister(): onRegister()", level: .info)
                                                        self?.firebaseRegister(view, login, psw)
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
    
    
    private func firebaseRegister(_ view: PushViewProtocol, _ login: MyAuth.login, _ psw: MyAuth.psw){
        FirebaseService.shared.signUp(login: login,
                                        psw: psw,
                                        onSuccess: { [weak self] (login, psw) in
                                          self?.log("FirebaseService(): register(): onSuccess()", level: .info)
                                          RealmService.saveFirebaseCredentials(login, psw)
                                            view.runPerformSegue(segueId: "showAppSegue", nil)
                                        },
                                        onError: { [weak self] (err) in
                                          self?.log("FirebaseService(): register(): onError(): \(err)", level: .error)
                                        })
    }
    
    private func firebaseSignIn(_ view: PushViewProtocol, _ login: MyAuth.login, _ psw: MyAuth.psw) {
        FirebaseService.shared.signIn(login: login,
                                        psw: psw,
                                        onSuccess: { [weak self] in
                                            self?.log("FirebaseService(): signIn(): onSuccess()", level: .info)
                                            RealmService.saveFirebaseCredentials(login, psw)
                                            view.runPerformSegue(segueId: "showAppSegue", nil)
                                        },
                                        onError: { [weak self] (err) in
                                          self?.log("FirebaseService(): signIn(): onError(): \(err)", level: .error)
                                        })
    }
}
