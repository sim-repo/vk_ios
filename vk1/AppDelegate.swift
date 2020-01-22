import UIKit
import Firebase
import Kingfisher


var appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KingfisherConfigurator.setup()
        ColorSystemHelper.setupDark()
        UIControlThemeMgt.setupTabBarColor()
        FirebaseApp.configure()
        LoginCoordinator.create()
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     }
}


