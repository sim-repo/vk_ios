import Foundation
import SwiftyJSON


class Group: SectionModelProtocol, DecodableProtocol {
   
    var id: typeId = 0
    var name: String = ""
    var desc: String = ""
    var icon: String = ""
    var avaURL50: String?
    var avaURL200: String?
    var image50: UIImage?
    var image200: UIImage?
    var groupBy: MyGroupByEnum = .name

    required init(){}
   

   
    func setup(json: JSON?){
       if let json = json {
           id = json["id"].doubleValue
           name = json["name"].stringValue
           desc = json["description"].stringValue
           avaURL50 = json["photo_50"].stringValue
           avaURL200 = json["photo_200"].stringValue
       }
    }
    
    
    
    
    func getId() -> typeId {
        return id
    }
    
    func getSortBy() -> String {
        return name
    }
   
    func getGroupBy()->String {
        switch groupBy {
          case .name:
              return name
        }
    }
}
