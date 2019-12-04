import SwiftyJSON

//MARK:- WallPhoto

extension NewsParser {
    
    
    struct NewsWallPostHeader {
        var avaURL: URL?
        var name = ""
        var unixTime: Double = 0
        var title = ""
    }
    
    struct NewsWallPostFooter {
        var views = 0
        var likes = 0
        var comments = 0
        var reposts = 0
    }
    
    
    public static func parseWallPhoto(_ jsonItem: JSON, groups: [typeId:Group], profiles: [typeId:Friend])  -> News? {
        let header = parsePostHeader(jsonItem, groups, profiles)
        let photoURLs = searchInItems(jsonItem)
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
        let type = jsonItem["type"].stringValue
        news.cellType = WallCellConstant.CellTypeEnum(rawValue: type) ?? .unknown
        
        
        // wall footer block
        news.viewCount = footer.views
        news.likeCount = footer.likes
        news.messageCount = footer.comments
        news.shareCount = footer.reposts
        
        
        return news
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
