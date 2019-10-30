import SwiftyJSON

class WallParser {
    
    

    public static func parseId(json: JSON) -> Int{
           return json["id"].intValue
    }
    
    public static func parseMyRepost(json: JSON, friends: [Int:Friend]) -> (URL?, String, Double, String){
        var avaUrl: URL?
        var name: String = ""
        var unixTime: Double = 0
        var title: String = ""

            if isRepost(json) {
                let myId = json["owner_id"].intValue
                if let f = friends[myId] {
                   if let url = f.avaURL100 {
                       avaUrl = URL(string: url)
                   }
                   name = f.firstName + " "+f.lastName
                   title = getTitle(json, false)
                   unixTime = getDate(json, false)
            }
        }
        return (avaUrl, name, unixTime, title)
    }
    
    
    public static func parseOrigPost(json: JSON, groups: [Int:Group]) -> (URL?, String, Double, String){
        var avaUrl: URL?
        var name: String = ""
        var unixTime: Double = 0
        var title: String = ""

        let repost = isRepost(json)
        let authorId = abs(getAuthorId(json, repost))
        if let g = groups[authorId] {
            if let url = g.avaURL200 {
                avaUrl = URL(string: url)
            }
            name = g.name
            title = getTitle(json, repost)
            unixTime = getDate(json, repost)
        }
        return (avaUrl, name, unixTime, title)
    }
    
    
    public static func parseImages(json: JSON) -> [URL] {
        var imageURLs: [URL] = []
        let repost = isRepost(json)
        let photos = getPhotos(json, repost)
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
        return imageURLs
    }

    
    public static func parseBottomBlock(json: JSON) -> (Int, Int, Int, Int){
        return (
            json["views"]["count"].intValue,
            json["likes"]["count"].intValue,
            json["comments"]["count"].intValue,
            json["reposts"]["count"].intValue
        )
    }
    
    
    
    public static func hasImages(json: JSON) -> Bool {
        let repost = isRepost(json)
        return hasPhotos(json, repost)
    }
    
    
    
    public static func isRepost(_ json: JSON) -> Bool {
        let arr = json["copy_history"].arrayValue
        return arr.count > 0
    }
    
    
    public static func hasPhotos(_ json: JSON, _ repost: Bool) -> Bool {
        if repost {
            if let histories = json["copy_history"].array {
                           for history in histories {
                                if let _ = history["attachments"].arrayValue.first(where: { $0["type"].stringValue == "photo" }) {
                                    return true
                                }
                            }
            }
            
        } else {
            if let _ = json["attachments"].arrayValue.first(where: { $0["type"].stringValue == "photo" }) {
                return true
            }
            
        }
         return false
    }
    
    
    
    public static func getAuthorId(_ json: JSON, _ repost: Bool) -> Int {
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
    
    
    
    public static func getPhotos(_ json: JSON, _ repost: Bool) -> [JSON] {
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
    
    
    public static func getTitle(_ json: JSON, _ repost: Bool) -> String {
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
    
    
    
    public static func getDate(_ json: JSON, _ repost: Bool) -> Double {
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
}
