import Foundation

class Like: ModelProtocol {
   
    var profileId = 0
    var itemId = 0
    var ownerId = 0
    var type: LikeType?
    var firstName = ""
    var lastName = ""
    var city = ""
    var avaURL100: URL?
    var online = false
    var isFriend = false
    
    func getId() -> Int {
       profileId
    }
    
    enum LikeType: String {
        case post, comment, photo, video
    }
}
