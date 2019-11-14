import UIKit


let baseURL = "https://api.vk.com/method/"
let versionAPI = "5.103"
let clientAPI = "7197054"

let networkTimeout: TimeInterval = 10 // in sec
let networkDelayBetweenRequests = 500 //500 // in ms
let networkLongDelayBetweenRequests = 5500 //500 // in ms

enum ModelLoadedFromEnum {
    case network
    case disk
}


enum SegueIdEnum: String {
    case detailFriend = "detailFriend"
    case detailGroup = "detailGroup"
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
