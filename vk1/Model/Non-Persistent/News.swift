import Foundation
import SwiftyJSON


class News : WallProtocol, DecodableProtocol, PlainModelProtocol {

    var id: typeId = 0
    var postTypeCode: String!
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
    
    
    required init(){}

    
    func setup(json: JSON?){}
    
    func setup(json: JSON?, profiles: [typeId:Friend], groups: [typeId:Group]) {
        
        if let json = json {
            id = NewsParser.parseId(json: json)
            
            ownerId = json["source_id"].intValue
            
            // wall header block
            (myAvaURL, myName, myPostDate, title) = NewsParser.parseMyRepost(json: json, profiles: profiles)
            
            (origAvaURL, origName, origPostDate, origTitle) = NewsParser.parseOrigPost(json: json, groups: groups, profiles: profiles)
            
            // wall image block
            imageURLs = NewsParser.parseImages(json: json)
            postTypeCode = getImagePlanCode(imageCount: imageURLs.count)
            
            // wall bottom block
            (viewCount, likeCount, messageCount, shareCount) = NewsParser.parseBottomBlock(json: json)
        }
    }
    
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
    
    // wall image block >>
    func getImageURLs() -> [URL] {
        return imageURLs
    }

    // wall bottom block >>
    
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