import Foundation

class FriendWall : WallProtocol{

    var id: Int!
    var postTypeCode: String
    var imageURLs: [String] = []
    var date: Date!
    var title: String!
    var likeCount = 0
    var viewCount = 0
    
    init(_ id: Int){
        self.id = id
        
        var index = Int(arc4random_uniform(UInt32(CommonElementDesigner.comments.count-1)))
        self.title = CommonElementDesigner.comments[index]
      
        
        let emojiCount = 1 + Int(arc4random_uniform(4))
        for _ in 0...emojiCount-1 {
                index = Int(arc4random_uniform(UInt32(CommonElementDesigner.emoji.count-1)))
                self.title += CommonElementDesigner.emoji[index]
        }
        
        
        let picCount = 1 + Int(arc4random_uniform(8))
        for _ in 0...picCount-1 {
            index = Int(arc4random_uniform(UInt32(CommonElementDesigner.pictures.count-1)))
            let pic = CommonElementDesigner.pictures[index]
            self.imageURLs.append(pic)
        }
        self.likeCount = Int(arc4random_uniform(100))
        self.viewCount = Int(arc4random_uniform(100))
        self.date = Date()
        
        switch imageURLs.count {
            case 1: postTypeCode = "tp1"
            case 2: postTypeCode = "tp2"
            case 3: postTypeCode = "tp3"
            case 4: postTypeCode = "tp4"
            case 5: postTypeCode = "tp5"
            case 6: postTypeCode = "tp6"
            case 7: postTypeCode = "tp7"
            case 8: postTypeCode = "tp8"
            case 9: postTypeCode = "tp9"
            default:
                postTypeCode = "tp9"
        }
    }
    
    func getImageURLs() -> [String] {
        return imageURLs
    }
    
    func getTitle() -> String? {
        return title
    }
    
    public class func list()->[FriendWall] {
        var res: [FriendWall] = []
        for i in 0...100 {
            let post = FriendWall(i)
            res.append(post)
        }
        
        return res
    }
}
