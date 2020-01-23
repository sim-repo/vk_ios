import UIKit


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
