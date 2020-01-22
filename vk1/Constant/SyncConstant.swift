import Foundation

struct SyncConstant {
    
    enum ModelLoadedFromEnum {
        case network
        case disk
    }
    
    // for bkg perform fetching
    enum UserDefaultsEnum: String {
        case lastSyncDate = "lastSyncDate"
    }
}
