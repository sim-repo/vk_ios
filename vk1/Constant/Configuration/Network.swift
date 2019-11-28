import UIKit


public struct Network {
    private init(){}
    public static let shared = Network()
    
    var clientId: String {
        return infoForKey("MY_VK_CLIEND_ID") ?? ""
    }

    var baseURL: String {
        return infoForKey("MY_VK_BASE_URL") ?? ""
    }
    
    var versionAPI: String {
        return infoForKey("MY_VK_API_VERSION") ?? ""
    }
    
    var clientSecret: String {
        return infoForKey("MY_VK_CLIEND_SECRET") ?? ""
    }
    
    static let timeout: TimeInterval = 10 // in sec
    static let delayBetweenRequests = 500 //500 // in ms
    static let longDelayBetweenRequests = 1000 //500 // in ms
    static let intervalViewReload = 5 // in percent
    static let newsResponseItemsPerRequest = 20 // in number
    static let wallResponseItemsPerRequest = 20 // in number
    static let maxIntervalBeforeCleanupDataSource = 60.0*5 //5 min
    static let minIntervalBeforeSendRequest = 30.0 //sec
    static let remItemsToStartFetch = 5 //in items
    
    func infoForKey(_ key: String) -> String? {
           return (Bundle.main.infoDictionary?[key] as? String)?
               .replacingOccurrences(of: "\\", with: "")
    }
}


struct MyAuth {
    typealias login = String
    typealias psw = String
    typealias token = String
    typealias userId = String
}

typealias onNetworkFinish_SyncCompletion = (SynchronizedPresenterProtocol) -> Void
typealias onSuccessResponse_SyncCompletion = () -> Void
typealias onErrResponse_SyncCompletion = (NSError) -> Void
typealias onSuccess_PresenterCompletion = ([DecodableProtocol]) -> Void
