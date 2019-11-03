import Foundation
import SwiftyJSON

class Friend: SectionModelProtocol, DecodableProtocol {
    
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var avaURL50: String?
    var avaURL100: String?
    var avaURL200: String?
    var groupBy: FriendGroupByEnum = .firstName
    
    required init(){}
    
    func getId()->Int{
        return id
    }
    
    func setup(json: JSON?) {
        if let json = json {
            id = json["id"].intValue
            firstName = json["first_name"].stringValue
            lastName = json["last_name"].stringValue
            avaURL50 = json["photo_50"].stringValue
            avaURL100 = json["photo_100"].stringValue
            avaURL200 = json["photo_200_orig"].stringValue
        }
    }
    
    func getGroupBy() -> String {
        switch groupBy {
        case .firstName:
            return firstName
        case .lastName:
            return lastName
        }
    }
}
