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
        vc!.presenter = presenter
        navigationController.pushViewController(vc!, animated: false)
    }

    func didPressTransition() {
        vc?.performSegue(withIdentifier: "showAppSegue", sender: nil)
    }
}



class MyGroupCoordinator: BaseCoordinator, PresentableCoordinatorProtocol {

    var vc: MyGroupListViewController?
    var presenter: MyGroupPresenter?
    var onRelease: (()->Void)?
    
    override func start(onRelease: (()->Void)? = nil) {
        self.onRelease = onRelease
        presenter = MyGroupPresenter()
        vc = MyGroupListViewController.instantiate(storyboardName: "MyGroup")
        vc!.presenter = presenter
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
