import SwiftyJSON

class NewsParser {
    
    
    //MARK:- called from networking service >>
    public static func parseNewsJson(_ val: Any, _ ownOffset: Int, _ vkOffset: String) -> [News]? {
        let json = JSON(val)

        var res: [News] = []
        let items = json["response"]["items"].arrayValue
        let jsonProfiles = json["response"]["profiles"].arrayValue
        let jsonGroups = json["response"]["groups"].arrayValue
        let dicGroups = parseGroup(jsonGroups)
        let dicProfile = parseProfiles(jsonProfiles)
        for j in items {
            let n = News()
            if NewsParser.hasImages(json: j) {
                n.setup(json: j, profiles: dicProfile, groups: dicGroups, ownOffset: ownOffset, vkOffset: vkOffset)
                res.append(n)
            }
        }
        return res
    }
    
    public static func parseNextOffset(_ val: Any) -> String? {
        let json = JSON(val)
        let offset = json["response"]["next_from"].stringValue
        return offset
    }
    
    
    //MARK:- called from model layer >>

    public static func parseId(json: JSON) -> typeId {
           return json["post_id"].intValue
    }

    
    public static func parseOrigPost(json: JSON, groups: [typeId:Group], profiles: [typeId:Friend]) -> (URL?, String, Double, String){
        var avaUrl: URL?
        var name: String = ""
        var unixTime: Double = 0
        var title: String = ""

        let authorId = abs(getAuthorId(json))
        unixTime = getDate(json)
        title = getTitle(json)
        
        
        if let g = groups[authorId] {
            avaUrl = g.avaURL200
            name = g.name
            title = getTitle(json)
            unixTime = getDate(json)
        }
        
        if let f = profiles[authorId] {
           avaUrl = f.avaURL100
           name = f.firstName + " "+f.lastName
           title = getTitle(json)
           unixTime = getDate(json)
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
            catchError(msg: "NewsParser(): parseImages() is Empty")
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
        return hasPhotos(json)
    }
    
    
    //MARK:- private functions >>

    
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
    
    
    private static func hasPhotos(_ json: JSON) -> Bool {
        if let _ = json["attachments"].arrayValue.first(where: { $0["type"].stringValue == "photo" }) {
                return true
            }
            
            if let j = json["attachments"].arrayValue.first(where: { $0["type"].stringValue == "link" }) {
                let h = j["link"]["photo"].dictionaryValue
                return h["sizes"] != nil
            }
            
            let j = json["type"].stringValue
            if j == "wall_photo" {
                return true
            }
         return false
    }
    
    
    
    private static func getAuthorId(_ json: JSON) -> typeId {
        return json["source_id"].intValue
    }
    
    
    
    private static func getPhotos(_ json: JSON) -> [JSON] {
        var photos: [JSON] = []
        
        if photos.isEmpty {
            photos = json["attachments"].arrayValue.filter({ (json) -> Bool in
            json["type"].stringValue == "photo" })
        }
        
        if photos.isEmpty {
            photos = json["photos"].arrayValue
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
    
    
    private static func getTitle(_ json: JSON) -> String {
        return json["text"].stringValue
    }
    
    
    private static func getDate(_ json: JSON) -> Double {
        return json["date"].doubleValue
    }
}
