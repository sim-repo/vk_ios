import SwiftyJSON

//MARK:- Post

extension NewsParser {
    
    struct NewsVideoHeader {
        var unixTime: Double = 0
        var title = ""
    }
    
    
    public static func parseVideo(_ jsonItem: JSON) -> News? {
        
        
        let header = parseVideoHeader(jsonItem)
        let photoURLs = searchInItems(jsonItem)
        let footer = parsePostFooter(jsonItem)
        let news = News()
        
        news.id =  jsonItem["id"].intValue
        if news.id == 0 {
            news.id = getRandomInt()
        }
        news.ownerId = jsonItem["source_id"].intValue
        
        // header block
        news.title = header.title
        news.postDate = header.unixTime
        
        
        // media block
        news.imageURLs = photoURLs
        news.imagesPlanCode = WallCellConstant.getImagePlanCode(imageCount: photoURLs.count)
        let type = jsonItem["type"].stringValue
        news.cellType = WallCellConstant.CellTypeEnum(rawValue: type) ?? .unknown
        
        var video = News.Video()
        video.id = jsonItem["id"].intValue
        video.ownerId = jsonItem["owner_id"].intValue
        let platform = jsonItem["platform"].stringValue
        if platform == "YouTube" {
            video.platform = .youtube
        }
        news.videos.append(video)
        
        
        // wall footer block
        news.viewCount = footer.views
        news.likeCount = footer.likes
        news.messageCount = footer.comments
        news.shareCount = footer.reposts
        
        return news
    }
    
    public static func parseVideoURL(_ val: Any) -> (URL?, WallCellConstant.VideoPlatform)? {
        let json = JSON(val)
        let items = json["response"]["items"].arrayValue
        
        if let item = items.first {
            let url = searchVideoFiles(item)
            let platformEnum = searchVideoPlatform(item)
            return (url, platformEnum)
        }
        return nil
    }
    
    private static func searchVideoFiles(_ jsonItem: JSON) -> URL? {
        let player = jsonItem["player"].stringValue
        let url = URL(string: player)
        return url
    }
    
    private static func searchVideoPlatform(_ jsonItem: JSON) -> WallCellConstant.VideoPlatform {
        let platform = jsonItem["platform"].stringValue
        if platform != "" {
            if let platformEnum = WallCellConstant.VideoPlatform.init(rawValue: platform) {
                return platformEnum
            }
        }
        return .other
    }
    
    
    
    
    //MARK:- header block:
    private static func parseVideoHeader(_ jsonItem: JSON) -> NewsVideoHeader {
        
        var header = NewsVideoHeader()
        header.unixTime = jsonItem["date"].doubleValue
        header.title = jsonItem["title"].stringValue
        return header
    }
    
    
    //MARK:- media block:
    
    private static func searchInItems(_ jsonItem: JSON) -> [URL] {
        
        var imageURLs = [URL]()
        var jsonURLs = [JSON]()
    
        if let url = searchInImageItem(jsonItem, tag1: "sizes") {
            jsonURLs.append(url)
        }
        
        if let url = searchInImageItem(jsonItem, tag1: "image") {
            jsonURLs.append(url)
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
        
        return imageURLs
    }
    
    private static func searchInImageItem(_ jsonItem: JSON, tag1: String) -> JSON? {
        let res = jsonItem[tag1].arrayValue.first(where: { (json) -> Bool in
            json["height"].intValue >= Int(WallCellConstant.mediaBlockHeight) && json["height"].intValue <= 400})
        return res
    }
    
}

