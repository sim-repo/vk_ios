import UIKit
import SwiftyJSON


class FriendWall : WallProtocol, DecodableProtocol, PlainModelProtocol {

    var id: Int!
    var postTypeCode: String!
    
    // header block
    var myAvaURL: URL?
    var myName: String = ""
    var myPostDate = ""
    var title: String = ""

    var origAvaURL: URL?
    var origName: String = ""
    var origPostDate = ""
    var origTitle: String = ""

    // image block
    var imageURLs: [URL] = []

    // bottom block
    var likeCount = 0
    var viewCount = 0
    var messageCount = 0
    var shareCount = 0
    
    required init(){}

    func getId()->Int{
       return id
    }
    
    func setup(json: JSON?) {
        if let json = json {
            id = json["id"].intValue
            print(json)
            //TODO:
            myPostDate = "xxxxxx"
            title = json["text"].stringValue
            viewCount = json["views"]["count"].intValue
            likeCount = json["likes"]["count"].intValue
            messageCount = json["comments"]["count"].intValue
            shareCount = json["reposts"]["count"].intValue
            
            let attachmentsWithPhoto = json["attachments"].arrayValue.filter({ (json) -> Bool in
                json["type"].stringValue == "photo"
            })
            
            postTypeCode = getImagePlanCode(imageCount: attachmentsWithPhoto.count)
            
          
            if let attachments = json["attachments"].array {
                for element in attachments {
                    let mPhotos = element["photo"]["sizes"].arrayValue.filter({ (json) -> Bool in
                        json["type"].stringValue == "q"
                    })
                    for photo in mPhotos {
                        if let url = URL(string: photo["url"].stringValue) {
                            imageURLs.append(url)
                        }
                    }
                }
            }
        }
    }
    

    // header block
    func getMyName() -> String? {
        return myName
    }
    
    func getMyAvaURL() -> URL? {
        return myAvaURL
    }
    
    func getMyPostDate() -> String? {
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
    
    
    func getOrigPostDate() -> String? {
        return origPostDate
    }
    
    func getOrigTitle() -> String? {
        return origTitle
    }
    
    // image block
    func getImageURLs() -> [URL] {
        return imageURLs
    }

    // bottom block
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
