import UIKit

protocol WallProtocol{
    
    // header block
    func getMyName() -> String?
    func getMyAvaURL() -> URL?
    func getMyPostDate() -> String?
    func getTitle() -> String?
    
    func getOrigName() -> String?
    func getOrigAvaURL() -> URL?
    func getOrigPostDate() -> String?
    func getOrigTitle() -> String?
    
    // images block
    func getImageURLs() -> [URL]
    
    
    // bottom block
    func getLikeCount() -> Int
    func getMessageCount() -> Int
    func getShareCount() -> Int
    func getEyeCount() -> Int
}



