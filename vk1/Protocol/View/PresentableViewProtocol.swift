import Foundation
import WebKit

// presenters get access to views
protocol PresentableViewProtocol: class {
    func startWaitIndicator(_ moduleEnum: ModuleEnum?)
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?)
}


protocol PresentablePlainViewProtocol : PresentableViewProtocol {
    func viewReloadData(moduleEnum: ModuleEnum)
    func insertItems(startIdx: Int, endIdx: Int)
}


protocol PresentableSectionedViewProtocol : PresentableViewProtocol {
    func viewReloadData(groupByIds: [String])
}


//MARK: - Specific Protocols

protocol PresentableWallViewProtocol : class {
    func playVideo(_ url: URL, _ platformEnum: WallCellConstant.VideoPlatform, _ indexPath: IndexPath)
    func showVideoError(_ indexPath: IndexPath, err: String)
}


protocol PresentableLoginViewProtocol : class {
    func showVkFormAuthentication(completion: ((WKWebView)->Void)?)
    func showFirebaseFormAuthentication(login: MyAuth.login,
                                        psw: MyAuth.psw,
                                        onSignIn: ((MyAuth.login, MyAuth.psw) -> Void)?,
                                        onRegister: (()->Void)?)
    func showFirebaseFormRegister(onRegister: ((MyAuth.login, MyAuth.psw) -> Void)?,
                                  onCancel: (()->Void)? )
    func back()
    func setRunAfterVkAuthentication(onVkAuthCompletion: ((MyAuth.token, MyAuth.userId)->Void)?)
}
