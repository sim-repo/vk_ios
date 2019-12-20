import SwiftyJSON

class WallParser {
    
    
    //MARK:- called from networking service >>
    public static func parseWallJson(_ val: Any, offset: Int)->[Wall]?{
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
                w.setup(json: j, profiles: dicProfile, groups: dicGroups, offset: offset)
                res.append(w)
            }
        }
        return res
    }
    
    
    
    //MARK:- called from model layer >>

    public static func parseId(json: JSON) -> typeId {
           return json["id"].intValue
    }
    
    
    public static func parseMyRepost(json: JSON, profiles: [typeId:Friend]) -> (URL?, String, Double, String){
        var avaUrl: URL?
        var name: String = ""
        var unixTime: Double = 0
        var title: String = ""

            if isRepost(json) {
                let myId = json["owner_id"].intValue
                if let f = profiles[myId] {
                   avaUrl = f.avaURL100
                   name = f.firstName + " "+f.lastName
                   title = getTitle(json, false)
                   unixTime = getDate(json, false)
                }
        }
        return (avaUrl, name, unixTime, title)
    }
    
    
    public static func parseOrigPost(json: JSON, groups: [typeId:Group], profiles: [typeId:Friend]) -> (URL?, String, Double, String){
        var avaUrl: URL?
        var name: String = ""
        var unixTime: Double = 0
        var title: String = ""

        let repost = isRepost(json)
        let authorId = abs(getAuthorId(json, repost))
        if let g = groups[authorId] {
            avaUrl = g.avaURL200 
            name = g.name
            title = getTitle(json, repost)
            unixTime = getDate(json, repost)
        }
        
        if let f = profiles[authorId] {
           avaUrl = f.avaURL100
           name = f.firstName + " "+f.lastName
           title = getTitle(json, repost)
           unixTime = getDate(json, repost)
        }
        return (avaUrl, name, unixTime, title)
    }
    
    
    public static func parseImages(json: JSON) -> [URL] {
        var imageURLs: [URL] = []
        let photos = getPhotos(json)
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
        if imageURLs.isEmpty {
            var photo: JSON?
            let sizes = ["l", "q", "p", "o", "m"]
            for size in sizes {
                photo = getPhoto(json, size:size)
                if photo != nil {
                    break
                }
            }
            if photo != nil {
                if let url = URL(string: photo!["url"].stringValue) {
                    imageURLs.append(url)
                }
            }
        }
       
        if imageURLs.isEmpty {
            Logger.catchError(msg: "WallParser() : parseImages(): is Empty")
        }
        return imageURLs
    }

    
    public static func parseFooterBlock(json: JSON) -> (Int, Int, Int, Int){
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
    
    
    //MARK:- private functions >>
    
    private static func isRepost(_ json: JSON) -> Bool {
        let arr = json["copy_history"].arrayValue
        return arr.count > 0
    }
    
    
    private static func parseProfiles(_ profiles: [JSON]) -> [typeId:Friend]{
        var res: [typeId:Friend] = [:]
        for json in profiles {
            let friend = Friend()
            friend.setup(json: json)
            res[friend.getId()] = friend
        }
        return res
    }
    
    private static func parseGroup(_ groups: [JSON]) -> [typeId:Group]{
        var res: [typeId:Group] = [:]
        for json in groups {
            let group = Group()
            group.setup(json: json)
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
            
            if let j = json["attachments"].arrayValue.first(where: { $0["type"].stringValue == "link" }) {
                let h = j["link"]["photo"].dictionaryValue
                return h["sizes"] != nil
            }
        }
         return false
    }
    
    
    
    private static func getAuthorId(_ json: JSON, _ repost: Bool) -> typeId {
        if repost {
            if let histories = json["copy_history"].array {
                for history in histories {
                    return history["from_id"].intValue
                }
            }
        } else {
             return json["from_id"].intValue
        }
        return 0
    }
    
    
    
    private static func getPhotos(_ json: JSON) -> [JSON] {
        var photos: [JSON] = []
        
        if let histories = json["copy_history"].array {
                           for history in histories {
                               photos = history["attachments"].arrayValue.filter({ (json) -> Bool in
                                               json["type"].stringValue == "photo"
                                           })
                           }
                       }
            
        if photos.isEmpty {
            photos = json["attachments"].arrayValue.filter({ (json) -> Bool in
            json["type"].stringValue == "photo" })
        }
        return photos
    }
    
    
    private static func getPhoto(_ json: JSON, size: String) -> JSON? {
        
        let links = json["attachments"].arrayValue.filter({ (json) -> Bool in
                json["type"].stringValue == "link" })
            

        for link in links  {
            return link["link"]["photo"]["sizes"].arrayValue.first(where: { $0["type"].stringValue == size})
        }
        return nil
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
