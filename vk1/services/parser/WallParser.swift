import SwiftyJSON

class WallParser {
    
    
    //MARK: called from networking service >>
    public static func parseWallJson(_ val: Any)->[Wall]?{
        let json = JSON(val)
        var res: [Wall] = []
        let items = json["response"]["items"].arrayValue
        let jsonProfiles = json["response"]["profiles"].arrayValue
        let jsonGroups = json["response"]["groups"].arrayValue
        let dicGroups = parseGroup(jsonGroups)
        let dicProfile = parseProfiles(jsonProfiles)
        for j in items {
            let w = Wall()
            if WallParser.hasImages(json: j) {
                w.setup(json: j, profiles: dicProfile, groups: dicGroups)
                res.append(w)
            }
        }
        return res
    }
    
    
    
    
    //MARK: called from model layer >>

    public static func parseId(json: JSON) -> Int{
           return json["id"].intValue
    }
    
    
    public static func parseMyRepost(json: JSON, profiles: [Int:Friend]) -> (URL?, String, Double, String){
        var avaUrl: URL?
        var name: String = ""
        var unixTime: Double = 0
        var title: String = ""

            if isRepost(json) {
                let myId = json["owner_id"].intValue
                if let f = profiles[myId] {
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
    
    
    public static func parseOrigPost(json: JSON, groups: [Int:Group], profiles: [Int:Friend]) -> (URL?, String, Double, String){
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
        
        if let f = profiles[authorId] {
           if let url = f.avaURL100 {
               avaUrl = URL(string: url)
           }
           name = f.firstName + " "+f.lastName
           title = getTitle(json, true)
           unixTime = getDate(json, true)
        }
        return (avaUrl, name, unixTime, title)
    }
    
    
    public static func parseImages(json: JSON) -> [URL] {
        var imageURLs: [URL] = []
        let repost = isRepost(json)
        let photos = getPhotos(json, repost)
           for photo in photos {
            
            // priority: q->x->m
            var mPhotos = photo["photo"]["sizes"].arrayValue.filter({ (json) -> Bool in
                   json["type"].stringValue == "q"})
            
            if mPhotos.count == 0 {
                mPhotos = photo["photo"]["sizes"].arrayValue.filter({ (json) -> Bool in
                json["type"].stringValue == "x" })
            }
            
            if mPhotos.count == 0 {
                mPhotos = photo["photo"]["sizes"].arrayValue.filter({ (json) -> Bool in
                json["type"].stringValue == "m" })
            }
            
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
    
    
    // validator:
    public static func hasImages(json: JSON) -> Bool {
        let repost = isRepost(json)
        return hasPhotos(json, repost)
    }
    
    
    //MARK: private functions
    
    private static func isRepost(_ json: JSON) -> Bool {
        let arr = json["copy_history"].arrayValue
        return arr.count > 0
    }
    
    
    private static func parseProfiles(_ profiles: [JSON]) -> [Int:Friend]{
        var res: [Int:Friend] = [:]
        for json in profiles {
            let friend = Friend()
            friend.setupFromWall(json: json)
            res[friend.getId()] = friend
        }
        return res
    }
    
    private static func parseGroup(_ groups: [JSON]) -> [Int:Group]{
        var res: [Int:Group] = [:]
        for json in groups {
            let group = Group()
            group.setupFromWall(json: json)
            res[group.getId()] = group
        }
        return res
    }
    
    
    private static func hasPhotos(_ json: JSON, _ repost: Bool) -> Bool {
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
    
    
    
    private static func getAuthorId(_ json: JSON, _ repost: Bool) -> Int {
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
    
    
    
    private static func getPhotos(_ json: JSON, _ repost: Bool) -> [JSON] {
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
    
    
    private static func getTitle(_ json: JSON, _ repost: Bool) -> String {
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
    
    
    
    private static func getDate(_ json: JSON, _ repost: Bool) -> Double {
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
