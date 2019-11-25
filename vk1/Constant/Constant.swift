import UIKit



struct Network {
    static let baseURL = "https://api.vk.com/method/"
    static let versionAPI = "5.103"
    static let clientAPI = "7221362"
    static let timeout: TimeInterval = 10 // in sec
    static let delayBetweenRequests = 500 //500 // in ms
    static let longDelayBetweenRequests = 1000 //500 // in ms
    static let intervalViewReload = 5 // in percent
    static let newsResponseItemsPerRequest = 20 // in number
    static let wallResponseItemsPerRequest = 20 // in number
    static let maxIntervalBeforeCleanupDataSource = 60.0*5 //5 min
    static let minIntervalBeforeSendRequest = 30.0 //sec
}


typealias onNetworkFinish_SyncCompletion = (SynchronizedPresenterProtocol) -> Void
typealias onSuccessResponse_SyncCompletion = () -> Void
typealias onErrResponse_SyncCompletion = (NSError) -> Void
typealias onSuccess_PresenterCompletion = ([DecodableProtocol]) -> Void


// for debug: fast way to enable console logging by area
enum PrintLogEnum {
    case realm, presenter, presenterCallsFromSync, presenterCallsFromView, sync, alamofire, viewReloadData
    
    var print: Bool {
        switch self {
        case .realm:
            return true
        case .presenter:
            return true
        case .presenterCallsFromSync:
            return true
        case .presenterCallsFromView:
            return true
        case .sync:
            return false
        case .alamofire:
            return false
        case .viewReloadData:
            return false
        }
    }
}

// for bkg perform fetching
enum UserDefaultsEnum: String {
    case lastSyncDate = "lastSyncDate"
}


enum ModelLoadedFromEnum {
    case network
    case disk
}


enum FriendGroupByEnum: String {
    case firstName = "By Name"
    case lastName = "By Surname"
}


enum MyGroupByEnum: String {
    case name = "By Name"
}

enum LogicPredicateEnum {
    case equal, notEqual
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



typealias typeId = Int

var isDark = true
