import Foundation


class LoginPresenter: PlainPresenterProtocols {
    
    
    var netFinishViewReload: Bool = false
    
    
    var modelClass: AnyClass  {
        return Login.self
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
    
    
    private func log(_ msg: String, isErr: Bool) {
      if isErr {
          catchError(msg: "PlainBasePresenter: \(self.clazz): " + msg)
      } else {
          console(msg: "PlainBasePresenter: \(self.clazz): " + msg, printEnum: .presenter)
      }
    }
}


// MARK: - override func


extension LoginPresenter {
    
    override func viewDidLoad() {
        if !loadVKCredentials() {
            
            guard let view_ = view as? PushLoginViewProtocol
            else {
                catchError(msg: "LoginPresenter(): downcasting: PushLoginViewProtocol")
            }
            view_.showVkAuthentication() { [weak self] in
                
            }
            
            
            runVkAuth() { [weak self] in
                guard let self = self else { return }
                if !self.loadFibCredentials() {
                    self.runFibAuth()
                }
            }
        }
    }
}
