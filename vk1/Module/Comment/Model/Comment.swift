import Foundation



class Comment {
   
    var id = 0
    var fromId = 0
    var postId = 0
    var ownerId = 0
    var date: Double = 0
    var text = ""
    var firstName = ""
    var lastName = ""
    var avaURL50: URL?
    var online = 0
    var imageURLs: [URL] = []
    var audio: [Audio] = []
    var newsSourceId = 0
    var newsPostId = 0
    

    struct Audio {
        var artist = ""
        var title = ""
        var url: URL?
    }
}


extension Comment: ModelProtocol {
    
    func getId() -> Int {
        id
    }
}
