import UIKit

protocol WallProtocol{
    
    // wall header block
    func getMyName() -> String?
    func getMyAvaURL() -> URL?
    func getMyPostDate() -> Double
    func getTitle() -> String?
    
    func getOrigName() -> String?
    func getOrigAvaURL() -> URL?
    func getOrigPostDate() -> Double
    func getOrigTitle() -> String?
    
    // wall images block
    func getImageURLs() -> [URL]
    
    
    // wall bottom block
    func getLikeCount() -> Int
    func getMessageCount() -> Int
    func getShareCount() -> Int
    func getEyeCount() -> Int
}



