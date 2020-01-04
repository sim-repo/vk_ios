import SwiftyJSON

//MARK:- Post

extension NewsParser {
    
    struct NewsPostHeader {
        var avaURL: URL?
        var name = ""
        var unixTime: Double = 0
        var title = ""
    }
    
    struct NewsPostFooter {
        var views = 0
        var likes = 0
        var comments = 0
        var reposts = 0
    }
    
    enum AttachmentEnum: String {
        case photo = "photo"
        case doc = "doc"
        case poll = "poll"
        case album = "album"
        case video = "video"
        case link = "link"
    }
    
    public static func parsePost(_ jsonItem: JSON, groups: [typeId:Group], profiles: [typeId:Friend], isRepost: Bool) -> News? {
        
        let header = parsePostHeader(jsonItem, groups, profiles)
        let photoURLs = parseImageBlock(jsonItem, isRepost)
        let videos = parseVideoBlock(jsonItem, isRepost)
        
        
        guard photoURLs.count >= 1 && photoURLs.count <= 9 || videos.count > 0 else { return nil }
        
        let footer = parsePostFooter(jsonItem)
        let news = News()
        
        news.id =  jsonItem["post_id"].intValue
        if news.id == 0 {
            news.id = getRandomInt()
        }
        news.ownerId = jsonItem["source_id"].intValue
       
            
        // header block
        news.avaURL = header.avaURL
        news.name = header.name
        news.title = header.title
        news.postDate = header.unixTime
    
            
        // media block
        news.imageURLs = photoURLs
        news.imagesPlanCode = WallCellConstant.getImagePlanCode(imageCount: photoURLs.count)
        news.videos = videos
        
        
        if news.videos.count > 0 {
            news.cellType = .video
        } else {
          news.cellType = .post
        }
    

        // wall footer block
        news.viewCount = footer.views
        news.likeCount = footer.likes
        news.messageCount = footer.comments
        news.shareCount = footer.reposts
        
        return news
    }
    
    
    //MARK:- header block:
    internal static func parsePostHeader(_ jsonItem: JSON, _ groups: [typeId:Group], _ profiles: [typeId:Friend]) -> NewsPostHeader {
        
        var postHeader = NewsPostHeader()
        
        let authorId = abs(jsonItem["source_id"].intValue)
        postHeader.unixTime = jsonItem["date"].doubleValue
        postHeader.title = jsonItem["text"].stringValue
        
        if let g = groups[authorId] {
            postHeader.avaURL = g.avaURL200
            postHeader.name = g.name
            postHeader.title = jsonItem["text"].stringValue
            postHeader.unixTime = jsonItem["date"].doubleValue
            return postHeader
        }
        
        if let f = profiles[authorId] {
            postHeader.avaURL = f.avaURL100
            postHeader.name = f.firstName + " "+f.lastName
            postHeader.title = jsonItem["text"].stringValue
            postHeader.unixTime = jsonItem["date"].doubleValue
            return postHeader
        }
        return postHeader
    }

    
    
    //MARK:- media block:
    
    internal static func parseImageBlock(_ jsonItem: JSON, _ isRepost: Bool) -> [URL] {
        
        var imageURLs = [URL]()
        var jsonURLs = [JSON]()
        
        if isRepost {
           jsonURLs = getImageURLsFromRepost(jsonItem)
        } else {
           jsonURLs = getImageURLs(jsonItem)
        }
        
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
    
    
    private static func getImageURLsFromRepost(_ jsonItem: JSON) -> [JSON] {
        
        var jsonURLs = [JSON]()
        
        if let histories = jsonItem["copy_history"].array {
            
            for history in histories {
                let urls = getImageURLs(history)
                for url in urls {
                    jsonURLs.append(url)
                }
            }
        }
        return jsonURLs
    }
    
    
    private static func getImageURLs(_ jsonItem: JSON) -> [JSON] {
        
        var photos = searchInAttachments(jsonItem, attachmentType: .photo)
        if photos.isEmpty {
            photos = searchInAttachments(jsonItem, attachmentType: .album)
        }
        if photos.isEmpty {
            photos = searchInAttachments(jsonItem, attachmentType: .doc)
        }
        if photos.isEmpty {
            photos = searchInAttachments(jsonItem, attachmentType: .link)
        }
        if photos.isEmpty {
            photos = searchInAttachments(jsonItem, attachmentType: .poll)
        }
        if photos.isEmpty {
            photos = searchInAttachments(jsonItem, attachmentType: .video)
        }
        return photos
    }
    
    
    private static func searchInAttachments(_ jsonItem: JSON, attachmentType: AttachmentEnum) -> [JSON] {
        
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
            
            if let item = searchInImageItems(attach, tag1: "photo", tag2: "sizes") {
                photos.append(item)
                continue
            }

            if let item = searchInImageItems(attach, tag1: "photo", tag2: "images") {
                photos.append(item)
                continue
            }

            if let item = searchInImageItems(attach, tag1: "thumb", tag2: "sizes") {
                photos.append(item)
                continue
            }


            if let item = searchInImageItems(attach, tag1: "video", tag2: "sizes") {
                photos.append(item)
                continue
            }


            if let item = searchInImageItems(attach, tag1: "video", tag2: "image") {
                photos.append(item)
                continue
            }

            if let item = searchInImageItems3(attach, tag1: "preview", tag2: "photo", tag3: "sizes") {
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
    
    
    internal static func parseVideoBlock(_ jsonItem: JSON, _ isRepost: Bool) -> [News.Video] {
        
        var videos = [News.Video]()
        
        if isRepost {
           videos = getVideosFromRepost(jsonItem)
        } else {
           videos = getVideos(jsonItem)
        }
        
        return videos
    }
    
    
    
    private static func getVideosFromRepost(_ jsonItem: JSON) -> [News.Video] {
       var res = [News.Video]()
               
       if let histories = jsonItem["copy_history"].array {
           
           for history in histories {
               let videos = getVideos(history)
               for video in videos {
                   res.append(video)
               }
           }
       }
       return res
    }
    
    private static func getVideos(_ jsonItem: JSON) -> [News.Video] {
        let items = jsonItem["attachments"].arrayValue.filter({ (json) -> Bool in
            json["type"].stringValue == "video" })
        var videos = [News.Video]()
        for item in items {
            var video = News.Video()
            video.id = item["video"]["id"].intValue
            video.ownerId = item["video"]["owner_id"].intValue
            video.platform = searchVideoPlatform(item)
            videos.append(video)
        }
        return videos
    }
    
       
   private static func searchVideoPlatform(_ jsonItem: JSON) -> WallCellConstant.VideoPlatform {
       let platform = jsonItem["video"]["platform"].stringValue
       if platform != "" {
           if let platformEnum = WallCellConstant.VideoPlatform.init(rawValue: platform) {
               return platformEnum
           }
       }
       return .other
   }
    
    //MARK:- footer block:
    
    public static func parsePostFooter(_ jsonItem: JSON) -> NewsPostFooter{
        var footer = NewsPostFooter()
        footer.likes = jsonItem["likes"]["count"].intValue
        footer.views = jsonItem["views"]["count"].intValue
        footer.comments = jsonItem["comments"]["count"].intValue
        footer.reposts = jsonItem["reposts"]["count"].intValue
        return footer
    }
}
