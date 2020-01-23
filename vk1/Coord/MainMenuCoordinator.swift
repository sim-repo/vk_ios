import UIKit


class MainMenuCoordinator: BaseCoordinator, PresentableCoordinatorProtocol {

    var rootVC1: FriendListViewController!
    var rootVC2: MyGroupListViewController!
    var rootVC3: ProfileTableViewController!
    var rootVC4: NewsListViewController!
    
    var rootPresenter1 = FriendListPresenter()
    var rootPresenter2 = MyGroupListPresenter()
    var rootPresenter3 = ProfilePresenter()
    var rootPresenter4 = NewsListPresenter()
    
    var navController1: UINavigationController!
    var navController2: UINavigationController!
    var navController3: UINavigationController!
    var navController4: UINavigationController!
    
    var onRelease: (()->Void)?
    
    override func start(onRelease: (()->Void)? = nil) {
        
        self.onRelease = onRelease
        
        // 1. bound sync to presenter
        let sync1 = SyncFriend(presenter: rootPresenter1)
        rootPresenter1.synchronizer = sync1
        let sync2 = SyncMyGroup(presenter: rootPresenter2)
        rootPresenter2.synchronizer = sync2
        
        // 2. set presenter role context
        rootPresenter1.setContext(role: .master)
        rootPresenter2.setContext(role: .master)
        rootPresenter3.setContext(role: .master)
        rootPresenter4.setContext(role: .master)
        
        // 3. bound coord to presenter
        rootPresenter1.setCoordinator(self)
        rootPresenter2.setCoordinator(self)
        rootPresenter3.setCoordinator(self)
        rootPresenter4.setCoordinator(self)
        
        // 4. create view
        rootVC1 = FriendListViewController.instantiate(storyboardName: "Friend")
        rootVC2 = MyGroupListViewController.instantiate(storyboardName: "MyGroup")
        rootVC3 = ProfileTableViewController.instantiate(storyboardName: "Profile")
        rootVC4 = NewsListViewController.instantiate(storyboardName: "Wall")
        
        
        // 5. bound view to presenter
        rootPresenter1.setView(view: rootVC1)
        
        // 6. bound presenter to view
        rootVC1.setPresenter(rootPresenter1)
        rootVC2.setPresenter(rootPresenter2)
        rootVC2.setPresenter(rootPresenter3)
        rootVC2.setPresenter(rootPresenter4)

        
        // 7. prepare navigation + tabbar controllers:
        navController1 = UINavigationController.init(rootViewController: rootVC1)
        navController2 = UINavigationController.init(rootViewController: rootVC2)
        navController3 = UINavigationController.init(rootViewController: rootVC3)
        navController4 = UINavigationController.init(rootViewController: rootVC4)
        
        let tabbarController = CustomTabBarController.instantiate(storyboardName: "Main")
        rootVC1.tabBarItem = UITabBarItem(title: "Друзья", image: UIImage(systemName: "f.circle.fill"), tag: 0)
        rootVC2.tabBarItem = UITabBarItem(title: "Сообщества", image: UIImage(systemName: "g.circle.fill"), tag: 1)
        rootVC3.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "p.circle.fill"), tag: 2)
        rootVC4.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(systemName: "n.circle.fill"), tag: 3)
        
        tabbarController.viewControllers = [navController1,navController2,navController3,navController4]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabbarController
    }
    
    func didPressTransition(to module: ModuleEnum, model: ModelProtocol) {
        let friend = model as! Friend
        showFriendWall(friend: friend, navController: navController1)
    }
    
    func didPressBack() {
        onRelease?()
    }
}


extension MainMenuCoordinator {
    
    private func showFriendWall(friend: Friend, navController: UINavigationController) {
        let coord = FriendWallCoordinator(navigationController: navController)
        store(coordinator: coord)
        coord.friend = friend
        coord.start(onRelease: { [weak self] in
            self?.free(coordinator: coord)
        })
        
    }
}
