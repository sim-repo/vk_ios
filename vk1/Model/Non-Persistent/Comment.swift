import Foundation
import SwiftyJSON


class Comment: PlainModelProtocol, DecodableProtocol {
   
    var id: typeId = 0
    var fromId: typeId = 0
    var postId: typeId = 0
    var ownerId: typeId = 0
    var date: Double = 0
    var text: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var avaURL50: URL?
    var online: Int = 0
    var imageURLs: [URL] = []
    var imagesPlanCode: String!
    var audio: [Audio] = []
    var newsSourceId: typeId = 0
    var newsPostId: typeId = 0
    
    required init(){}

    func setup(json: JSON?){
    }
    
    func getId() -> typeId {
        return id
    }
    
    func getSortBy() -> String {
        return firstName
    }
    
    struct Audio {
        var artist: String = ""
        var title: String = ""
        var url: URL?
    }
}
