import SwiftyJSON


class NewsParser {
    
    
    //MARK:- called from networking service >>
    
    private static func getNewsType(_ jsonItem: JSON) -> WallCellConstant.CellTypeEnum {
        let type = jsonItem["type"].stringValue
        
        switch type {
        
        case WallCellConstant.CellTypeEnum.post.rawValue:
            return WallCellConstant.CellTypeEnum.post
        
        case WallCellConstant.CellTypeEnum.wall_photo.rawValue:
            return WallCellConstant.CellTypeEnum.wall_photo
        
        case WallCellConstant.CellTypeEnum.video.rawValue:
            return WallCellConstant.CellTypeEnum.video
        
        case WallCellConstant.CellTypeEnum.audio.rawValue:
            break
            
        default:
            break
        }
        return WallCellConstant.CellTypeEnum.audio
    }
    
    
    private static func isRepost(_ jsonItem: JSON) -> Bool {
        let arr = jsonItem["copy_history"].arrayValue
        return arr.count > 0
    }
    
    public static func parseJson(_ val: Any, _ ownOffset: Int, _ vkOffset: String) -> [News]? {
        let json = JSON(val)
        
        
        var res: [News] = []
        let items = json["response"]["items"].arrayValue
        
        let jsonProfiles = json["response"]["profiles"].arrayValue
        let jsonGroups = json["response"]["groups"].arrayValue
        let dicGroups = parseGroup(jsonGroups)
        let dicProfile = parseProfiles(jsonProfiles)
        
      
        
        for item in items {
            
            let repost = isRepost(item)
            
            var news: News?
            switch getNewsType(item){
                case .post:
                    news = parsePost(item, groups: dicGroups, profiles: dicProfile, isRepost: repost)
                    break
                
                case .wall_photo:
                    news = parseWallPhoto(item, groups: dicGroups, profiles: dicProfile)
                    break
                
                case .video:
                    news = parseVideo(item, groups: dicGroups, profiles: dicProfile)
                    break
                
                case .audio:
                        break
            }
            
            if let news_ = news {
                news_.ownOffset = ownOffset
                news_.vkOffset = vkOffset
                news_.createDate = getUnixTime(date: Date())
                res.append(news_)
            }
        }
        return res
    }
    

    public static func parseNextOffset(_ val: Any) -> String? {
        let json = JSON(val)
        let offset = json["response"]["next_from"].stringValue
        return offset
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
    
    
    private static func hasPhotos(_ jsonItem: JSON) -> Bool {
        if let _ = jsonItem["attachments"].arrayValue.first(where: { $0["type"].stringValue == "photo" }) {
            return true
        }
        
        if let j = jsonItem["attachments"].arrayValue.first(where: { $0["type"].stringValue == "link" }) {
            let h = j["link"]["photo"].dictionaryValue
            return h["sizes"] != nil
        }
        
        if jsonItem["type"].stringValue == "wall_photo" {
            return true
        }
        return false
    }

}
