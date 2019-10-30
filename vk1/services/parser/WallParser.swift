import SwiftyJSON

class WallParser {
    
    
    public static func hasImages(json: JSON) -> Bool {
        let repost = isRepost(json)
        return hasPhotos(json, repost)
    }
    
    
    
    private static func isRepost(_ json: JSON) -> Bool {
        let arr = json["copy_history"].arrayValue
        return arr.count > 0
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
}
