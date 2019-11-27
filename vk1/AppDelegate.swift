import UIKit
import Firebase




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // color themes:
        ColorSystemHelper.setupDark()
        UIControlThemeMgt.setupTabBarColor()
        // bkg update config:
        let syncConfiguration = DefaultSyncConfiguration()
        UIApplication.shared.setMinimumBackgroundFetchInterval(syncConfiguration.interval)
        //firebase:
        FirebaseApp.configure()
        return true
    }

    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         // Start background fetch
         SyncMgt.shared.startScheduledSync { (hasNewData) in
             completionHandler(hasNewData ? .newData : .noData)
         }
     }
}

