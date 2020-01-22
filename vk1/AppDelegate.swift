import UIKit
import Firebase
import Kingfisher


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KingfisherConfigurator.setup()
        ColorSystemHelper.setupDark()
        UIControlThemeMgt.setupTabBarColor()
        FirebaseApp.configure()
        setupLoginController()
        return true
    }

    func setupLoginController(){
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        let loginCoord = LoginCoordinator(navigationController: navController)
        loginCoord.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     }
}


