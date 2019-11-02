import UIKit



let versionAPI = "5.103"
let clientAPI = "7192541"

let networkTimeout: TimeInterval = 1 // in sec
let networkDelayBetweenRequests = 500 // in ms


enum LoadModelType{
    case networkFirst
    case diskFirst
}


enum FriendGroupByType: String {
    case firstName = "По Имени"
    case lastName = "По Фамилии"
}


enum PresenterEnum  {
    case friendPresenter
    case detailFriendPresenter
    case myGroupPresenter
    case myGroupDetailPresenter
    case groupPresenter
    case wallPresenter
    case friendWallPresenter
    case profilePresenter
    case loginPresenter
    
    init(presenterType: PresenterProtocol.Type) {
        switch presenterType {
        case is FriendPresenter.Type:
                   self = .friendPresenter
        case is DetailFriendPresenter.Type:
                   self = .detailFriendPresenter
        case is MyGroupPresenter.Type:
                   self = .myGroupPresenter
        case is MyGroupDetailPresenter.Type:
                   self = .myGroupDetailPresenter
        case is GroupPresenter.Type:
                   self = .groupPresenter
        case is WallPresenter.Type:
                   self = .wallPresenter
        case is FriendWallPresenter.Type:
                   self = .friendWallPresenter
        case is ProfilePresenter.Type:
                   self = .profilePresenter
        default:
            self = .friendPresenter
            catchError(msg: "")
        }
    }
    
    init(presenter: PresenterProtocol) {
        switch presenter {
        case is FriendPresenter:
                   self = .friendPresenter
        case is DetailFriendPresenter:
                   self = .detailFriendPresenter
        case is MyGroupPresenter:
                   self = .myGroupPresenter
        case is MyGroupDetailPresenter:
                   self = .myGroupDetailPresenter
        case is GroupPresenter:
                   self = .groupPresenter
        case is WallPresenter:
                   self = .wallPresenter
        case is FriendWallPresenter:
                   self = .friendWallPresenter
        case is ProfilePresenter:
                   self = .profilePresenter
        case is LoginPresenter:
            self = .loginPresenter
        default:
            self = .friendPresenter
            catchError(msg: "")
        }
    }
    
    init(vc: ViewInputProtocol) {
        switch vc {
        case is Friend_Controller:
                   self = .friendPresenter
        case is FriendWall_Controller:
                   self = .detailFriendPresenter
        case is MyGroups_ViewController:
                   self = .myGroupPresenter
        case is MyGroupDetail_ViewController:
                   self = .myGroupDetailPresenter
        case is Group_ViewController:
                   self = .groupPresenter
        case is Wall_Controller:
                   self = .wallPresenter
        case is FriendWall_Controller:
                   self = .friendWallPresenter
        case is Profile_TableViewController:
                   self = .profilePresenter
        case is LoginViewController:
                   self = .loginPresenter
        default:
            self = .friendPresenter
            catchError(msg: "")
        }
    }
    
    
    var vc: ViewInputProtocol.Type {
           switch self {
               case .friendPresenter:
                   return Friend_Controller.self
               case .detailFriendPresenter:
                   return FriendWall_Controller.self
               case .myGroupPresenter:
                   return MyGroups_ViewController.self
               case .myGroupDetailPresenter:
                   return MyGroupDetail_ViewController.self
               case .groupPresenter:
                   return Group_ViewController.self
               case .wallPresenter:
                   return Wall_Controller.self
               case .friendWallPresenter:
                   return FriendWall_Controller.self
               case .profilePresenter:
                    return Profile_TableViewController.self
               case .loginPresenter:
                    return LoginViewController.self
           }
       }
    
    var presenter: PresenterProtocol.Type {
        switch self {
            case .friendPresenter:
                return FriendPresenter.self
            case .detailFriendPresenter:
                return DetailFriendPresenter.self
            case .myGroupPresenter:
                return MyGroupPresenter.self
            case .myGroupDetailPresenter:
                return MyGroupDetailPresenter.self
            case .groupPresenter:
                return GroupPresenter.self
            case .wallPresenter:
                return WallPresenter.self
            case .friendWallPresenter:
                return FriendWallPresenter.self
            case .profilePresenter:
                return ProfilePresenter.self
            case .loginPresenter:
                return LoginPresenter.self
        }
    }
}






enum FriendImagesType: Int {
   case image50
   case image200
}


enum MyGroupByType: String {
    case name = "По Названию"
}


enum GroupImagesType: Int{
    case image50
    case image200
}

enum WallImagesType: Int{
    case m
    case l
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



typealias onSuccessSyncCompletion = ()->Void
typealias onErrSyncCompletion = (NSError)->Void
typealias onSuccessPresenterCompletion = ([DecodableProtocol]) -> Void
