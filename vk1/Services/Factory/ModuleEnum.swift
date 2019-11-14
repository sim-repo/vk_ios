import Foundation


enum ModuleEnum  {
    
    case friend
    case friend_wall
    case my_group
    case my_group_detail
    case my_group_wall
    case group
    case wall
    case profile
    case login
    case unknown
    
    init(presenterType: SynchronizedPresenterProtocol.Type) {
        switch presenterType {
        case is FriendPresenter.Type:
            self = .friend
        case is FriendWallPresenter.Type:
            self = .friend_wall
        case is MyGroupPresenter.Type:
            self = .my_group
        case is MyGroupDetailPresenter.Type:
            self = .my_group_detail
        case is MyGroupWallPresenter.Type:
            self = .my_group_wall
        case is GroupPresenter.Type:
            self = .group
        case is WallPresenter.Type:
            self = .wall
        case is ProfilePresenter.Type:
            self = .profile
        default:
            self = .unknown
            catchError(msg: "ModuleEnum: init(:SynchronizedPresenterProtocol.Type): no case: \(presenterType)")
        }
    }
    
    init(presenter: SynchronizedPresenterProtocol) {
        switch presenter {
        case is FriendPresenter:
            self = .friend
        case is FriendWallPresenter:
            self = .friend_wall
        case is MyGroupPresenter:
            self = .my_group
        case is MyGroupDetailPresenter:
            self = .my_group_detail
        case is MyGroupWallPresenter:
            self = .my_group_wall
        case is GroupPresenter:
            self = .group
        case is WallPresenter:
            self = .wall
        case is ProfilePresenter:
            self = .profile
        case is LoginPresenter:
            self = .login
        default:
            self = .unknown
            catchError(msg: "ModuleEnum: init(:SynchronizedPresenterProtocol): no case: \(presenter)")
        }
    }
    
    init(vc: PushViewProtocol) {
        switch vc {
        case is Friend_Controller:
            self = .friend
        case is FriendWall_ViewController:
            self = .friend_wall
        case is MyGroups_ViewController:
            self = .my_group
        case is MyGroupDetail_ViewController:
            self = .my_group_detail
        case is Group_ViewController:
            self = .group
        case is Wall_Controller:
            self = .wall
        case is Profile_TableViewController:
            self = .profile
        case is LoginViewController:
            self = .login
        default:
            self = .unknown
            catchError(msg: "ModuleEnum: init(:PushViewProtocol): no case: \(vc)")
        }
    }
    
    init(segueId: SegueIdEnum) {
        switch segueId {
        case .detailFriend:
            self = .friend_wall
        case .detailGroup:
            self = .my_group_detail
        }
    }
    
    
    var vc: PushViewProtocol.Type {
        switch self {
        case .friend:
            return Friend_Controller.self
        case .friend_wall:
            return FriendWall_ViewController.self
        case .my_group:
            return MyGroups_ViewController.self
        case .my_group_detail:
            return MyGroupDetail_ViewController.self
        case .my_group_wall:
            return MyGroupDetail_ViewController.self
        case .group:
            return Group_ViewController.self
        case .wall:
            return Wall_Controller.self
        case .profile:
            return Profile_TableViewController.self
        case .login:
            return LoginViewController.self
        case .unknown:
            return Friend_Controller.self //TODO
        }
    }
    
    var presenter: SynchronizedPresenterProtocol.Type {
        switch self {
        case .friend:
            return FriendPresenter.self
        case .friend_wall:
            return FriendWallPresenter.self
        case .my_group:
            return MyGroupPresenter.self
        case .my_group_detail:
            return MyGroupDetailPresenter.self
        case .my_group_wall:
            return MyGroupWallPresenter.self
        case .group:
            return GroupPresenter.self
        case .wall:
            return WallPresenter.self
        case .profile:
            return ProfilePresenter.self
        case .login:
            return LoginPresenter.self
        case .unknown:
            return FriendPresenter.self //TODO
        }
    }
    
}

