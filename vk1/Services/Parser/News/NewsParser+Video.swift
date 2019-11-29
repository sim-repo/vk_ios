import SwiftyJSON

//MARK:- Video

extension NewsParser {
    
    public static func parseVideo(_ jsonItem: JSON, groups: [typeId:Group], profiles: [typeId:Friend])  -> News? {
        return nil
    }
    
    
    
    
    
    public static func parseVideos(_ jsonItem_: JSON) -> [News.Video] {
        var result = [News.Video]()
        let videoItems = jsonItem_["video"]["items"].arrayValue
        for item in videoItems {
            var video = News.Video()
            video.id = item["id"].intValue
            video.ownerId = item["owner_id"].intValue
            if let imageURL = item["image"].arrayValue.first(where: { (json) -> Bool in
                json["height"].intValue >= 120 && json["height"].intValue <= 450 })?.stringValue {
            
                video.coverImageURL = URL(string: imageURL)
            }
            result.append(video)
        }
        return result
    }
    
}
