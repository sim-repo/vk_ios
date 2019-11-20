import Foundation
import SwiftyJSON

class Friend: SectionModelProtocol, DecodableProtocol {
    
    var id: typeId = 0
    var firstName: String = ""
    var lastName: String = ""
    var avaURL50: URL?
    var avaURL100: URL?
    var avaURL200: URL?
    var groupBy: FriendGroupByEnum = .firstName

    required init(){}
    
    func setup(json: JSON?) {
        if let json = json {
            id = json["id"].intValue
            firstName = json["first_name"].stringValue
            lastName = json["last_name"].stringValue
            avaURL50 = URL(string: json["photo_50"].stringValue)
            avaURL100 = URL(string: json["photo_100"].stringValue)
            avaURL200 = URL(string: json["photo_200_orig"].stringValue)
        }
    }
    
    func getId() -> typeId {
        return id
    }
    
    func getSortBy() -> String {
        switch groupBy {
            case .firstName:
                return firstName
            case .lastName:
                return lastName
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
