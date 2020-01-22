import Foundation

class MyGroup: ModelProtocol {
    
    var id = 0
    var name = ""
    var desc = ""
    var avaURL50: URL?
    var avaURL200: URL?
    var coverURL400: URL?
    var membersCount = 0
    var isClosed = 0
    var isDeactivated = 0
    
    
    func getId() -> Int {
        id
    }
}


