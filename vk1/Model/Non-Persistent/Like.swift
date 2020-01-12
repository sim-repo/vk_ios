import Foundation
import SwiftyJSON


class Like: PlainModelProtocol, DecodableProtocol {
   
    var itemId: typeId = 0
    var ownerId: typeId = 0
    var type: LikeType?
    var profileId: typeId = 0
    var firstName: String = ""
    var lastName: String = ""
    var city: String = ""
    var avaURL100: URL?
    var online: Bool = false
    var isFriend: Bool = false
    
    required init(){}
    
    func setup(json: JSON?){}
    
    func getId() -> typeId {
        return profileId
    }
    
    func getSortBy() -> String {
        return ""
    }
    
    enum LikeType: String {
        case post, comment, photo, video
    }
}
