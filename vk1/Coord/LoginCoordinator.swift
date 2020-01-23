import UIKit

class LoginCoordinator: BaseCoordinator {

    var vc: LoginViewController?
    var presenter: LoginPresenter?
    var syncLogin: SyncVkLogin?
    
    override func start(onRelease: (()->Void)? = nil) {
        syncLogin = SyncVkLogin()
        presenter = LoginPresenter(coordinator: self, synchronizer: syncLogin!)
        presenter?.synchronizer = syncLogin
        vc = LoginViewController.instantiate(storyboardName: "Main")
        vc?.modalPresentationStyle = .fullScreen
        presenter?.view = vc
        vc!.setPresenter(presenter!)
        navigationController.pushViewController(vc!, animated: false)
    }

    func didPressTransition() {
        showMainMenu()
        //vc?.performSegue(withIdentifier: "showAppSegue", sender: nil)
    }
    
    static func create(){
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        let coord = LoginCoordinator(navigationController: navController)
        coord.start()
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    private func showMainMenu(){
        let coord = MainMenuCoordinator(navigationController: navigationController)
        coord.start()
    }
}
