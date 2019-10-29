import Foundation
import SwiftyJSON


class Wall : WallProtocol, DecodableProtocol, PlainModelProtocol {
    
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
    
    
    func setup(json: JSON?){}
    
    func setup(json: JSON?, friends: [Int:Friend], groups: [Int:Group]) {
        if let json = json {
            let repost = isRepost(json)
            
            id = json["id"].intValue
            print(json)
     
            let myId = json["owner_id"].intValue
            let authorId = abs(getAuthorId(json, repost))
            
            if let f = friends[myId] {
                if let url = f.avaURL100 {
                    myAvaURL = URL(string: url)
                }
                myName = f.firstName + " "+f.lastName
                let unixTime = getDate(json, false)
                myPostDate = convertUnixTime(unixTime: unixTime)
            }
            
            if let g = groups[authorId] {
                if let url = g.avaURL200 {
                    origAvaURL = URL(string: url)
                }
                origName = g.name
                origTitle = getTitle(json, repost)
                
                let unixTime = getDate(json, repost)
                origPostDate = convertUnixTime(unixTime: unixTime)
            }
            
            
            title = getTitle(json, false)
            viewCount = json["views"]["count"].intValue
            likeCount = json["likes"]["count"].intValue
            messageCount = json["comments"]["count"].intValue
            shareCount = json["reposts"]["count"].intValue
            
            
            let photos = getPhotos(json, repost)
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
    
    
    private func isRepost(_ json: JSON) -> Bool {
        let arr = json["copy_history"].arrayValue
        return arr.count > 0
    }
    
    
    private func getAuthorId(_ json: JSON, _ repost: Bool) -> Int {
        if repost {
            if let histories = json["copy_history"].array {
                for history in histories {
                    return history["owner_id"].intValue
                }
            }
        } else {
             return json["owner_id"].intValue
        }
        return 0
    }
    
    private func getPhotos(_ json: JSON, _ repost: Bool) -> [JSON] {
        var photos: [JSON] = []
        if repost {
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
    
    
    private func getTitle(_ json: JSON, _ repost: Bool) -> String {
        if repost {
            if let histories = json["copy_history"].array {
                for history in histories {
                    return history["text"].stringValue
                }
            }
        } else {
             return json["text"].stringValue
        }
        return ""
    }
    
    private func getDate(_ json: JSON, _ repost: Bool) -> Double {
        if repost {
            if let histories = json["copy_history"].array {
                for history in histories {
                    return history["date"].doubleValue
                }
            }
        } else {
             return json["date"].doubleValue
        }
        return 0
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
