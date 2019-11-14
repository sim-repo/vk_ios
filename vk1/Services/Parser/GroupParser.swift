import SwiftyJSON

class GroupParser {
    
    public static func parseCoverURL400(json: JSON) -> URL? {
        let cover = json["cover"]["images"].arrayValue.first(where: {$0["width"].intValue > 200})
        if let _cover = cover {
            let url = _cover["url"].stringValue
            return URL(string: url)
        }
        return nil
    }
    
}

    
