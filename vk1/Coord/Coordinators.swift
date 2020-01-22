import UIKit


protocol Coordinator : class {
    var childCoordinators : [Coordinator] { get set }
    func start(onRelease: (()->Void)?)
}

extension Coordinator {

    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

protocol PresentableCoordinatorProtocol {
    func didPressTransition(to module: ModuleEnum, model: ModelProtocol)
    func didPressBack()
}


class BaseCoordinator : Coordinator {
    var childCoordinators : [Coordinator] = []
    var isCompleted: (() -> ())?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(onRelease: (()->Void)? = nil) {
        fatalError("Children should implement `start`.")
    }
}


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
        
        
        let sync1 = SyncFriend(presenter: rootPresenter1)
        rootPresenter1.synchronizer = sync1
        let sync2 = SyncMyGroup(presenter: rootPresenter2)
        rootPresenter2.synchronizer = sync2
        
        rootPresenter1.setContext(role: .master)
        rootPresenter2.setContext(role: .master)
        rootPresenter3.setContext(role: .master)
        rootPresenter4.setContext(role: .master)
        
        rootVC1 = FriendListViewController.instantiate(storyboardName: "Friend")
        rootVC2 = MyGroupListViewController.instantiate(storyboardName: "MyGroup")
        rootVC3 = ProfileTableViewController.instantiate(storyboardName: "Profile")
        rootVC4 = NewsListViewController.instantiate(storyboardName: "Wall")
        
        
        rootPresenter1.setView(view: rootVC1)
        
        rootVC1.setPresenter(rootPresenter1)
        rootVC2.setPresenter(rootPresenter2)
        rootVC2.setPresenter(rootPresenter3)
        rootVC2.setPresenter(rootPresenter4)

        
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
    }
    
    func didPressBack() {
        onRelease?()
    }
}






class MyGroupCoordinator: BaseCoordinator, PresentableCoordinatorProtocol {

    var vc: MyGroupListViewController?
    var presenter: MyGroupListPresenter?
    var onRelease: (()->Void)?
    
    override func start(onRelease: (()->Void)? = nil) {
        self.onRelease = onRelease
        presenter = MyGroupListPresenter()
        vc = MyGroupListViewController.instantiate(storyboardName: "MyGroup")
        vc!.setPresenter(presenter!)
        navigationController.pushViewController(vc!, animated: false)
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


class MyGroupDetailCoordinator: BaseCoordinator, PresentableCoordinatorProtocol {
    
    var vc: MyGroupDetailViewController?
    var presenter: MyGroupDetailPresenter?
    var myGroup: MyGroup?
    var onRelease: (()->Void)?
    
    override func start(onRelease: (()->Void)? = nil) {
        self.onRelease = onRelease
        presenter = MyGroupDetailPresenter()
        presenter?.myGroup = myGroup
        vc = MyGroupDetailViewController.instantiate(storyboardName: "MyGroup")
        vc!.presenter = presenter
        navigationController.pushViewController(vc!, animated: false)
    }
    
    func didPressTransition(to module: ModuleEnum, model: ModelProtocol) {
        
    }
    
    func didPressBack() {
        presenter = nil
        vc = nil
        onRelease?()
    }
}




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
