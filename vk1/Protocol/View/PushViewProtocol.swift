import Foundation
import WebKit

// presenters get access to views
protocol PushViewProtocol: class {
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?)
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?)
}


protocol PushSectionedViewProtocol : PushViewProtocol {
    func viewReloadData(groupByIds: [String])
}


protocol PushPlainViewProtocol : PushViewProtocol {
    func viewReloadData(moduleEnum: ModuleEnum)
    func insertItems(startIdx: Int, endIdx: Int)
}


//MARK: - Specific Protocols

protocol PushLoginViewProtocol {
    
    func showVkFormAuthentication(completion: ((WKWebView)->Void)?)
    func showFirebaseFormAuthentication(login: MyAuth.login,
                                        psw: MyAuth.psw,
                                        onSignIn: ((MyAuth.login, MyAuth.psw) -> Void)?,
                                        onRegister: (()->Void)?)
    
    
    func showFirebaseFormRegister(onRegister: ((MyAuth.login, MyAuth.psw) -> Void)?,
                                  onCancel: (()->Void)? )
    
    func back()
    func runPerformSegue(segueId: String)
    
    func setRunAfterVkAuthentication(onVkAuthCompletion: ((MyAuth.token, MyAuth.userId)->Void)?)
}
