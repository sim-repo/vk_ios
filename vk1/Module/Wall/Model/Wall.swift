import Foundation

class Wall : ModelProtocol, WallModelProtocol {
    
    var id = 0
    var ownerId = 0
    var type: WallCellConstant.CellEnum = .unknown
    
    // header block
    var reposterAvaURL: URL?
    var reposterName = ""
    var reposterPostDate: Double = 0
    var reposterTitle = ""
    
    var authorAvaURL: URL?
    var authorName = ""
    var authorPostDate: Double = 0
    var authorTitle = ""
    
    // image block
    var imageURLs: [URL] = []
    
    // footer block
    var likeCount = 0
    var viewCount = 0
    var messageCount = 0
    var shareCount = 0
    
    var offset = 0
    
    func getId() -> Int {
        id
    }
    
    func getType() -> WallCellConstant.CellEnum {
        type
    }
}
