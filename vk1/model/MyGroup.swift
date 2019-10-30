import Foundation
import SwiftyJSON

class MyGroup: SectionedModelProtocol, DecodableProtocol {
    var id: Int = 0
    var name: String = ""
    var desc: String = ""
    var avaURL50: URL?
    var avaURL200: URL?
    var groupBy: MyGroupByType = .name
    
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
        }
    }
    
    func setupFromWall(json: JSON?){
           setup(json: json)
           let dict:[String: SectionedModelProtocol] = ["model": self]
           NotificationCenter.default.post(name: .groupInserted, object: nil, userInfo: dict)
    }
    
    func getGroupByField()->String {
         switch groupBy {
           case .name:
               return name
         }
    }
}


