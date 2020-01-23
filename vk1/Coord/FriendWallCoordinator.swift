import UIKit

class FriendWallCoordinator: BaseCoordinator, PresentableCoordinatorProtocol {

    var vc: FriendWallViewController!
    var presenter = FriendWallPresenter()
    var onRelease: (()->Void)?
    
    var friend: Friend?
    var wall: Wall?
    var backTitle = ""
    
    override func start(onRelease: (()->Void)? = nil) {
        
        self.onRelease = onRelease
        
        
        presenter.setMaster(master: friend ?? wall! )
        
        let sync = SyncFriendWall(presenter: presenter)
        presenter.synchronizer = sync
        
        presenter.setCoordinator(self)
        presenter.setContext(role: .detail)
        
        vc = FriendWallViewController.instantiate(storyboardName: "Friend")
        vc.setPresenter(presenter)
        presenter.setView(view: vc)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func didPressTransition(to module: ModuleEnum, model: ModelProtocol) {
        switch module {
        case .friendWall:
            let wall = model as! Wall
            showFriendWall(wall: wall, navController: navigationController)
        default:
            break
        }
    }
    
    func didPressBack() {
        onRelease?()
    }
}


extension FriendWallCoordinator {
    
     private func showFriendWall(wall: Wall, navController: UINavigationController) {
           let coord = FriendWallCoordinator(navigationController: navController)
           store(coordinator: coord)
           coord.wall = wall
           coord.backTitle = friend?.firstName ?? ""
           coord.start(onRelease: { [weak self] in
               self?.free(coordinator: coord)
           })
           
       }
}
