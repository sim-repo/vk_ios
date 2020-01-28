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
    
    var avaImage50: UIImage?
    var avaImage100: UIImage?
    var avaImage200: UIImage?
    
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
    
    
    func setImages(avaImage50: UIImage? = nil, avaImage100: UIImage? = nil, avaImage200: UIImage?  = nil) {
        self.avaImage50 = avaImage50
        self.avaImage100 = avaImage100
        self.avaImage200 = avaImage200
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
