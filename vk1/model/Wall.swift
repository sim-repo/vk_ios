import Foundation
import SwiftyJSON

class Wall : WallProtocol, DecodableProtocol, PlainModelProtocol {
    
    var id: Int!
    var postTypeCode: String!
    var imageURLs: [URL] = []
    var date: Date!
    var title: String!
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
            //print(json)
            //TODO:
            date = Date()
            title = json["text"].stringValue
            viewCount = json["views"]["count"].intValue
            likeCount = json["likes"]["count"].intValue
            messageCount = json["comments"]["count"].intValue
            shareCount = json["reposts"]["count"].intValue
             
            
            let photos = getPhotos(json: json)
            postTypeCode = getImagePlanCode(imageCount: photos.count)
            
            
            for photo in photos {
                let mPhotos = photo["photo"]["sizes"].arrayValue.filter({ (json) -> Bool in
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
    
    private func getPhotos(json: JSON) -> [JSON] {
        var photos: [JSON] = []
        let arr = json["copy_history"].arrayValue
        if arr.count > 0 {
            if let histories = json["copy_history"].array {
                           for history in histories {
                               photos = history["attachments"].arrayValue.filter({ (json) -> Bool in
                                               json["type"].stringValue == "photo"
                                           })
                           }
                       }
            
        } else {
            photos = json["attachments"].arrayValue.filter({ (json) -> Bool in
                            json["type"].stringValue == "photo" })
        }
         return photos
    }

    
    
    func getImageURLs() -> [URL] {
        return imageURLs
    }
    
    func getTitle() -> String? {
        return title
    }
    
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
