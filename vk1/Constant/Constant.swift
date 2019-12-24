import UIKit


// for debug purpose only: fast way to enable console logging by area
enum PrintLogEnum {
    case realm, presenter, presenterCallsFromSync, presenterCallsFromView, sync, alamofire, viewReloadData, login, pagination, warning
    
    var print: Bool {
        switch self {
        case .realm:
            return true
        case .presenter:
            return false
        case .presenterCallsFromSync:
            return false
        case .presenterCallsFromView:
            return false
        case .sync:
            return true
        case .alamofire:
            return true
        case .viewReloadData:
            return false
        case .login:
            return false
        case .pagination:
            return false
        case .warning:
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


typealias typeId = Int

var isDark = true

