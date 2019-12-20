import Foundation
import SwiftyJSON


class Wall : DecodableProtocol, PlainModelProtocol {

    var id: typeId = 0
    var postTypeCode: String!
    var cellType: WallCellConstant.CellTypeEnum = .unknown
    var ownerId = 0
    
    // wall header block
    var myAvaURL: URL?
    var myName: String = ""
    var myPostDate: Double = 0
    var title: String = ""
    
    var origAvaURL: URL?
    var origName: String = ""
    var origPostDate: Double = 0
    var origTitle: String = ""
    
    // wall image block
    var imageURLs: [URL] = []
    
    // wall bottom block
    var likeCount = 0
    var viewCount = 0
    var messageCount = 0
    var shareCount = 0
    
    var offset = 0
    
    required init(){}

    
    func setup(json: JSON?){}
    
    func setup(json: JSON?, profiles: [typeId:Friend], groups: [typeId:Group], offset: Int) {
        
        if let json = json {

            id = WallParser.parseId(json: json)
            
            ownerId = json["owner_id"].intValue
            
            // wall header block
            (myAvaURL, myName, myPostDate, title) = WallParser.parseMyRepost(json: json, profiles: profiles)
            
            (origAvaURL, origName, origPostDate, origTitle) = WallParser.parseOrigPost(json: json, groups: groups, profiles: profiles)
            
            // wall image block
            imageURLs = WallParser.parseImages(json: json)
            postTypeCode = WallCellConstant.getImagePlanCode(imageCount: imageURLs.count)
            
            // wall footer block
            (viewCount, likeCount, messageCount, shareCount) = WallParser.parseFooterBlock(json: json)
            
            self.offset = offset
        }
    }
    
}

    
extension Wall: WallModelProtocol {

    
    func getId() -> typeId {
        return id
    }
    
    func getSortBy() -> String {
        return "\(origPostDate)"
    }
    
    // wall header block >>
    func getMyName() -> String? {
        return myName
    }
    
    func getMyAvaURL() -> URL? {
        return myAvaURL
    }
    
    func getMyPostDate() -> Double {
        return myPostDate
    }
    
    func getTitle() -> String? {
        return title
    }
    
    func getOrigName() -> String? {
        return origName
    }
    
    func getOrigAvaURL() -> URL? {
        return origAvaURL
    }
    
    
    func getOrigPostDate() -> Double {
        return origPostDate
    }
    
    func getOrigTitle() -> String? {
        return origTitle
    }
    
    // wall media block >>
    func getImageURLs() -> [URL] {
        return imageURLs
    }
    
    func getCellType() -> WallCellConstant.CellTypeEnum {
        return cellType
    }
    

    // wall footer block >>
    
    func getLikeCount() -> Int {
           return likeCount
    }
    
    func getMessageCount()->Int {
          return messageCount
    }
      
    func getShareCount()->Int {
      return shareCount
    }

    func getEyeCount()->Int {
      return viewCount
    }

}
