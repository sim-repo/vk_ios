import Foundation
import SwiftyJSON

class DetailGroup: DecodableProtocol, PlainModelProtocol {
    
    // get from network >>
    var id: Double = 0
    var photosCounter: Int = 0
    var albumsCounter: Int = 0
    var topicsCounter: Int = 0
    var videosCounter: Int = 0
    var marketCounter: Int = 0
    var coverURL400: URL?
    
    // set from MyGroup class >>
    var name: String = ""
    var desc: String = ""
    var avaURL50: URL?
    var avaURL200: URL?
    var membersCount: Int = 0
    var isClosed: Int = 0
    var isDeactivated: Int = 0
    
    required init(){}
    
    func setup(json: JSON?){
        if let json = json {
           id = json["id"].doubleValue
           photosCounter = json["counters"]["photos"].intValue
           albumsCounter = json["counters"]["albums"].intValue
           topicsCounter = json["counters"]["topics"].intValue
           videosCounter = json["counters"]["videos"].intValue
           marketCounter = json["counters"]["market"].intValue
           coverURL400 = GroupParser.parseCoverURL400(json: json)
           console(msg: "DetailGroup created!")
        }
    }
    
    func setup(group: MyGroup) {
        name = group.name
        desc = group.desc
        avaURL50 = group.avaURL50
        avaURL200 = group.avaURL200
        membersCount = group.membersCount
        isClosed = group.isClosed
        isDeactivated = group.isDeactivated
    }
    
    func getId() -> typeId{
        return id
    }
    
    func getSortBy() -> String {
        return "\(id)"
    }
}
