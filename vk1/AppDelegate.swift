import UIKit

var isDark = true


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ColorSystemHelper.setupDark()
        UIControlThemeMgt.setupTabBarColor()
        let syncConfiguration = DefaultSyncConfiguration()
        UIApplication.shared.setMinimumBackgroundFetchInterval(syncConfiguration.interval)
        return true
    }

    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         // Start background fetch
         SynchronizerManager.shared.startScheduledSync { (hasNewData) in
             completionHandler(hasNewData ? .newData : .noData)
         }
     }
}

