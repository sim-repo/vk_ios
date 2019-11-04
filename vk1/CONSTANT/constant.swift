import UIKit


let baseURL = "https://api.vk.com/method/"
let versionAPI = "5.103"
let clientAPI = "7192541"

let networkTimeout: TimeInterval = 1 // in sec
let networkDelayBetweenRequests = 500 // in ms


enum ModelLoadedFromEnum {
    case network
    case disk
}


enum SegueIdEnum: String {
    case detailFriend = "detailFriend"
    case detailGroup = "detailGroup"
}


enum ModuleEnum  {
    case friend
    case friend_wall
    case my_group
    case my_group_detail
    case group
    case wall
    case profile
    case login
    
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
        case is GroupPresenter.Type:
                   self = .group
        case is WallPresenter.Type:
                   self = .wall
        case is ProfilePresenter.Type:
                   self = .profile
        default:
            self = .friend
            catchError(msg: "")
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
        case is GroupPresenter:
                   self = .group
        case is WallPresenter:
                   self = .wall
        case is ProfilePresenter:
                   self = .profile
        case is LoginPresenter:
            self = .login
        default:
            self = .friend
            catchError(msg: "")
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
            self = .friend
            catchError(msg: "")
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
               case .group:
                   return Group_ViewController.self
               case .wall:
                   return Wall_Controller.self
               case .profile:
                    return Profile_TableViewController.self
               case .login:
                    return LoginViewController.self
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
            case .group:
                return GroupPresenter.self
            case .wall:
                return WallPresenter.self
            case .profile:
                return ProfilePresenter.self
            case .login:
                return LoginPresenter.self
        }
    }
}



enum FriendGroupByEnum: String {
    case firstName = "By Name"
    case lastName = "By Surname"
}


enum MyGroupByEnum: String {
    case name = "By Name"
}


func getImagePlanCode(imageCount: Int) -> String {
    switch imageCount {
        case 1: return "tp1"
        case 2: return "tp2"
        case 3: return "tp3"
        case 4: return "tp4"
        case 5: return "tp5"
        case 6: return "tp6"
        case 7: return "tp7"
        case 8: return "tp8"
        case 9: return "tp9"
        default:
            return "tp9"
    }
}

var cellByCode = ["tp1": "Wall_Cell_tp1",
                 "tp2": "Wall_Cell_tp2",
                 "tp3": "Wall_Cell_tp3",
                 "tp4": "Wall_Cell_tp4",
                 "tp5": "Wall_Cell_tp5",
                 "tp6": "Wall_Cell_tp6",
                 "tp7": "Wall_Cell_tp7",
                 "tp8": "Wall_Cell_tp8",
                 "tp9": "Wall_Cell_tp9"]


var cellHeaderHeight: CGFloat = 240
var cellQuarterHeight: CGFloat = 240 / 4
var cellImageHeight: CGFloat = 180
var cellBottomHeight: CGFloat = 30


extension Notification.Name {
    static let friendInserted = Notification.Name("friendInserted")
    static let groupInserted = Notification.Name("groupInserted")
}



typealias onNetworkFinish_SyncCompletion = (SynchronizedPresenterProtocol) -> Void
typealias onSuccessResponse_SyncCompletion = () -> Void
typealias onErrResponse_SyncCompletion = (NSError) -> Void
typealias onSuccess_PresenterCompletion = ([DecodableProtocol]) -> Void


typealias typeId = Double
