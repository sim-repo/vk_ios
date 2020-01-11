import SwiftyJSON


class CommentParser {
    
    
    struct Profile {
        var id: typeId = 0
        var firstName: String = ""
        var lastName: String = ""
        var photo_50: String = ""
        var online: Int = 0
    }
    
    enum AttachmentEnum: String {
        case sticker = "sticker"
        case audio = "audio"
        case photo = "photo"
        case video = "video"
    }
    
    
    public static func parseJson(_ val: Any) -> [Comment]? {
        let json = JSON(val)
       // print(json)
        
        var comments = [Comment]()
        
        let items = json["response"]["items"].arrayValue
        let jsonProfiles = json["response"]["profiles"].arrayValue
        let profiles = parseProfiles(jsonProfiles)
        
        
        for item in items {
            
            let photoURLs = parseImageBlock(item)
            let audio = parseAudioBlock(item)
            
            let comment = Comment()
            comment.id = item["id"].intValue
            comment.postId = item["post_id"].intValue
            comment.fromId = item["from_id"].intValue
            comment.ownerId = item["owner_id"].intValue
            comment.text = item["text"].stringValue
            comment.date = item["date"].doubleValue
            
            if let profile = profiles.first(where: {$0.id == comment.fromId}) {
                comment.firstName = profile.firstName
                comment.lastName = profile.lastName
                comment.avaURL50 = URL(string: profile.photo_50)
                comment.online = profile.online
            }
            
            comment.imageURLs = photoURLs
            comment.imagesPlanCode = WallCellConstant.getImagePlanCode(imageCount: photoURLs.count)
            comment.audio = audio
            comments.append(comment)
        }
        
        let sorted = comments.sorted {
            $0.date < $1.date
        }
        return sorted
    }
    
    
    private static func parseProfiles(_ jsonProfiles: [JSON]) -> [Profile] {
        var res: [Profile] = []
        for profileJson in jsonProfiles {
            var profile = Profile()
            profile.id = profileJson["id"].intValue
            profile.firstName = profileJson["first_name"].stringValue
            profile.lastName = profileJson["last_name"].stringValue
            profile.photo_50 = profileJson["photo_100"].stringValue
            profile.online = profileJson["online"].intValue
            res.append(profile)
        }
        return res
    }
    
    
    //MARK:- image block:
    
    internal static func parseImageBlock(_ jsonItem: JSON) -> [URL] {
        
        var imageURLs = [URL]()
        var jsonURLs = [JSON]()
        
        jsonURLs = getImageURLs(jsonItem)
        
        for j in jsonURLs {
            var sUrl = j["url"].stringValue
            if sUrl == "" {
                sUrl = j["src"].stringValue
            }
            if let url = URL(string: sUrl) {
                imageURLs.append(url)
            }
        }
        
        if imageURLs.isEmpty {
            Logger.catchError(msg: "NewsParser(): parseImages() is Empty")
        }
        return imageURLs
    }
    
    
    private static func getImageURLs(_ jsonItem: JSON) -> [JSON] {
        
        var photos = searchImagesInAttachments(jsonItem, attachmentType: .photo)
        if photos.isEmpty {
            photos = searchImagesInAttachments(jsonItem, attachmentType: .sticker)
        }
        if photos.isEmpty {
            photos = searchImagesInAttachments(jsonItem, attachmentType: .video)
        }
        return photos
    }
    
    
    private static func searchImagesInAttachments(_ jsonItem: JSON, attachmentType: AttachmentEnum) -> [JSON] {
        
        let items = jsonItem["attachments"].arrayValue.filter({ (json) -> Bool in
            json["type"].stringValue == attachmentType.rawValue })
        var photos = [JSON]()
        for item in items {
            let attach = item[attachmentType.rawValue].self
            
            if let image = searchInImageItems2(attach, tag1: "sizes") {
                photos.append(image)
                continue
            }
            
            if let image = searchInImageItems2(attach, tag1: "image") {
                photos.append(image)
                continue
            }
            
            if let image = searchInImageItems2(attach, tag1: "images") {
                photos.append(image)
                continue
            }
            
            if let item = searchInImageItems(attach, tag1: "photo", tag2: "sizes") {
                photos.append(item)
                continue
            }
            
            if let item = searchInImageItems(attach, tag1: "photo", tag2: "images") {
                photos.append(item)
                continue
            }
            
            if let item = searchInImageItems(attach, tag1: "sticker", tag2: "images") {
                photos.append(item)
                continue
            }
        }
        
        return photos
    }
    
    
    private static func searchInImageItems(_ jsonItem: JSON, tag1: String, tag2: String) -> JSON? {
        let res = jsonItem[tag1][tag2].arrayValue.first(where: { (json) -> Bool in
            json["height"].intValue >= Int(WallCellConstant.mediaBlockHeight) /*&& json["height"].intValue <= 400*/})
        return res
    }
    
    private static func searchInImageItems2(_ jsonItem: JSON, tag1: String) -> JSON? {
        //        let res = jsonItem[tag1].arrayValue.last
        let res = jsonItem[tag1].arrayValue.first(where: { (json) -> Bool in
            json["height"].intValue >= Int(WallCellConstant.mediaBlockHeight) /*&& json["height"].intValue <= 400*/})
        return res
    }
    
    private static func searchInImageItems3(_ jsonItem: JSON, tag1: String, tag2: String, tag3: String) -> JSON? {
        let res = jsonItem[tag1][tag2][tag3].arrayValue.first(where: { (json) -> Bool in
            json["height"].intValue >= Int(WallCellConstant.mediaBlockHeight) /*&& json["height"].intValue <= 400*/})
        return res
    }
    
    
    
    //MARK:- audio block:
    
    private static func parseAudioBlock(_ jsonItem: JSON) -> [Comment.Audio] {
        
        let items = jsonItem["attachments"].arrayValue.filter({ (json) -> Bool in
            json["type"].stringValue == AttachmentEnum.audio.rawValue })
        
        var audioArr = [Comment.Audio]()
        
        for item in items {
            var audio = Comment.Audio()
            let attach = item[AttachmentEnum.audio.rawValue].self
            audio.artist = attach["artist"].stringValue
            audio.title = attach["title"].stringValue
            audio.url = URL(string: attach["url"].stringValue)
            audioArr.append(audio)
        }
        return audioArr
    }
    
}
