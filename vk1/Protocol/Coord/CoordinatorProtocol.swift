import UIKit


protocol CoordinatorProtocol : class {
    var childCoordinators : [CoordinatorProtocol] { get set }
    func start(onRelease: (()->Void)?)
}

extension CoordinatorProtocol {

    func store(coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}


class BaseCoordinator : CoordinatorProtocol {
    var childCoordinators : [CoordinatorProtocol] = []
    var isCompleted: (() -> ())?
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(onRelease: (()->Void)? = nil) {
        fatalError("Children should implement `start`.")
    }
}
