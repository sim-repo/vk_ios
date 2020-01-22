import UIKit

class Group: ModelProtocol {
   
    var id = 0
    var name = ""
    var desc = ""
    var icon = ""
    var avaURL50: URL?
    var avaURL200: URL?
    var image50: UIImage?
    var image200: UIImage?
    var coverURL400: URL?
    var membersCount = 0
    var isClosed = 0
    var isDeactivated = 0
    
    func getId() -> Int {
        id
    }
    
    func getSortBy() -> String {
        return name
    }
}
