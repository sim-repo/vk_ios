import Foundation
import SwiftyJSON

class MyGroup: SectionedModelProtocol, DecodableProtocol {
    var id: Int = 0
    var name: String = ""
    var desc: String = ""
    var avaURL50: URL?
    var avaURL200: URL?
    var groupBy: MyGroupByEnum = .name
    var coverURL400: URL?
    var membersCount: Int = 0
    var isClosed: Int = 0
    var isDeactivated: Int = 0
    
    
    required init(){}
    
    func getId()->Int{
        return id
    }
    
    func setup(json: JSON?){
        if let json = json {
            id = json["id"].intValue
            name = json["name"].stringValue
            desc = json["description"].stringValue
            avaURL50 = URL(string: json["photo_50"].stringValue)
            avaURL200 = URL(string: json["photo_200"].stringValue)
            membersCount = json["members_count"].intValue
            coverURL400 = GroupParser.parseCoverURL400(json: json)
            isClosed = json["is_closed"].intValue
            isDeactivated = json["deactivated"].intValue
        }
    }
    
    func getGroupByField()->String {
         switch groupBy {
           case .name:
               return name
         }
    }
}


