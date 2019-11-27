import Foundation


class LoginPresenter: PlainPresenterProtocols {
    
    
    var netFinishViewReload: Bool = false
    
    
    var modelClass: AnyClass  {
        return Login.self
    }
    
    
    private func log(_ msg: String, isErr:Bool = false) {
      if isErr {
          catchError(msg: "LoginPresenter: \(self.clazz): " + msg)
      } else {
          console(msg: "LoginPresenter: \(self.clazz): " + msg, printEnum: .login)
      }
    }
}


// MARK: - authentication flow

extension LoginPresenter {
    
    override func viewDidLoad() {
        
        guard let view_ = view as? PushLoginViewProtocol
        else {
            log("viewDidLoad(): downcasting: PushLoginViewProtocol", isErr: true)
            return
        }
        
        view_.setRunAfterVkAuthentication(onVkAuthCompletion: { [weak self] (token, userId) in
            self?.log("setRunAfterVkAuthentication()")
            RealmService.saveVKCredentials(token, userId)
            Session.shared.set(token, userId)
            self?.checkFirebaseCredentials(view: view_)
        })
        
        
        checkVKCredentials(
            onSuccess: { [weak self] in
                self?.log("checkVKCredentials(): checked success")
                self?.checkFirebaseCredentials(view: view_)
            },
            onError: { [weak self] in
                self?.log("checkVKCredentials(): checked failed")
                view_.showVkFormAuthentication() {  (webview) in
                    self?.log("checkVKCredentials(): showVkFormAuthentication()")
                    SyncMgt.shared.doVkAuth(webview: webview)
                }
            })
    }
    
    
    private func checkVKCredentials(onSuccess: (()->Void)?, onError: (()->Void)?) {
        if let (t,u) = RealmService.loadToken(),
            let token = t,
            let userId = u {
                log("checkVKCredentials(): loadToken(): success")
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
    

    private func checkFirebaseCredentials(view: PushLoginViewProtocol) {
        let (login, psw) = self.loadFirebaseCredentials()
        view.showFirebaseFormAuthentication(login: login,
                                            psw: psw,
                                            onSignIn: { [weak self] (login, psw) in
                                                self?.log("runFirebaseAuthentication(): onSignIn()")
                                                self?.firebaseSignIn(view, login, psw)
                                            },
                                            onRegister: { [weak self] in
                                                self?.log("runFirebaseAuthentication(): onRegister()")
                                                view.showFirebaseFormRegister(
                                                    onRegister: { [weak self] (login, psw) in
                                                        self?.log("showFirebaseFormRegister(): onRegister()")
                                                        self?.firebaseRegister(view, login, psw)
                                                    },
                                                    onCancel: {  [weak self] in
                                                        self?.log("showFirebaseFormRegister(): onCancel()")
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
    
    
    private func firebaseRegister(_ view: PushLoginViewProtocol, _ login: MyAuth.login, _ psw: MyAuth.psw){
        FirebaseService.shared.signUp(login: login,
                                        psw: psw,
                                        onSuccess: { [weak self] (login, psw) in
                                          self?.log("FirebaseService(): register(): onSuccess()")
                                          RealmService.saveFirebaseCredentials(login, psw)
                                          view.runPerformSegue(segueId: "showAppSegue")
                                        },
                                        onError: { [weak self] (err) in
                                          self?.log("FirebaseService(): register(): onError(): \(err)", isErr: true)
                                        })
    }
    
    private func firebaseSignIn(_ view: PushLoginViewProtocol, _ login: MyAuth.login, _ psw: MyAuth.psw) {
        FirebaseService.shared.signIn(login: login,
                                        psw: psw,
                                        onSuccess: { [weak self] in
                                            self?.log("FirebaseService(): signIn(): onSuccess()")
                                            RealmService.saveFirebaseCredentials(login, psw)
                                            view.runPerformSegue(segueId: "showAppSegue")
                                        },
                                        onError: { [weak self] (err) in
                                          self?.log("FirebaseService(): signIn(): onError(): \(err)", isErr: true)
                                        })
    }
}
