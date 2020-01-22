import Foundation

class MyGroupDetail : ModelProtocol {
    
    var id = 0
    var photosCounter = 0
    var albumsCounter = 0
    var topicsCounter = 0
    var videosCounter = 0
    var marketCounter = 0
    var coverURL400: URL?
    
    var myGroup: MyGroup?
    
    func getId() -> Int{
        id
    }
}
