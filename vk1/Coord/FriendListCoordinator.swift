import UIKit

class FriendListCoordinator: BaseCoordinator, PresentableCoordinatorProtocol {

    var vc: FriendListViewController?
    var presenter: FriendListPresenter?
    var onRelease: (()->Void)?
    
    override func start(onRelease: (()->Void)? = nil) {
        self.onRelease = onRelease
        presenter = FriendListPresenter()
        vc = FriendListViewController.instantiate(storyboardName: "Friend")
        vc!.setPresenter(presenter!)
        
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let nav = CustomNavigationController.instantiate(storyboardName: "Friend")
//        appDelegate.window?.rootViewController = nav
//        nav.pushViewController(vc!, animated: false)
        
        
        let vc2 = MyGroupListViewController()
        let vc3 = ProfileTableViewController()
        let vc4 = NewsListViewController()
        
        let nav1 = UINavigationController.init(rootViewController: vc!)
        let nav2 = UINavigationController.init(rootViewController: vc2)
        let nav3 = UINavigationController.init(rootViewController: vc3)
        let nav4 = UINavigationController.init(rootViewController: vc4)
        let tabbarController = CustomTabBarController.instantiate(storyboardName: "Main")
        vc!.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        vc3.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        vc4.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 3)
        
        
        tabbarController.viewControllers = [nav1,nav2,nav3,nav4]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabbarController
        
    }
    
    func didPressTransition(to module: ModuleEnum, model: ModelProtocol) {
        switch module {
        case .myGroupDetail:
            let myGroup = model as! MyGroup
            showMyGroupDetail(myGroup: myGroup)
        default:
            break
        }
    }
    
    func didPressBack() {
        onRelease?()
    }
    
    private func showMyGroupDetail(myGroup: MyGroup){
        let coord = MyGroupDetailCoordinator(navigationController: navigationController)
        store(coordinator: coord)
        coord.myGroup = myGroup
        coord.start(onRelease: { [weak self] in
            self?.free(coordinator: coord)
        })
    }
}
