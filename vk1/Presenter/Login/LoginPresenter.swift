import Foundation


class LoginPresenter: PlainPresenterProtocols {
    
    
    var netFinishViewReload: Bool = false
    
    
    var modelClass: AnyClass  {
        return Login.self
    }
}


