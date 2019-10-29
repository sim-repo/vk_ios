import Foundation
import SwiftyJSON


class Group: SectionedModelProtocol {
   
   var id: Int = 0
   var name: String = ""
   var desc: String = ""
   var icon: String = ""
   var avaURL50: String?
   var avaURL200: String?
   var image50: UIImage?
   var image200: UIImage?
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
           avaURL50 = json["photo_50"].stringValue
           avaURL200 = json["photo_200"].stringValue
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
