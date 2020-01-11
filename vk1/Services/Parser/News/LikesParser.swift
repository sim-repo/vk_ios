import SwiftyJSON


class LikesParser {
    
    public static func parseLikeJson(_ itemId: Int, _ ownerId: Int, _ val: Any, type: Like.LikeType) -> [Like]? {
        let json = JSON(val)
        var res: [Like] = []
        
        let items = json["response"]["items"].arrayValue
        for item in items {
            
            let like = Like()
            like.itemId = itemId
            like.ownerId = ownerId
            like.type = type
            like.profileId = item["id"].intValue
            like.firstName = item["first_name"].stringValue
            like.lastName = item["last_name"].stringValue
            res.append(like)
        }
        return res
    }
    
    public static func parseUserJson(_ likes: [Like], _ val: Any) -> [Like]? {
        let json = JSON(val)
        let items = json["response"].arrayValue
        for item in items {
            let userId = item["id"].intValue
            let city = item["city"]["title"].stringValue
            let avaURL100 = item["photo_100"].stringValue
            let online = item["online"].intValue
            if let like = likes.first(where: {$0.profileId == userId}) {
                like.avaURL100 = URL(string: avaURL100)
                like.city = city
                like.online = online == 1 ? true : false
            }
        }
        return likes
    }
    
}
