import UIKit

protocol WallProtocol{
    func getImageURLs()->[URL]
    func getTitle()->String?
    func getLikeCount()->Int
    func getMessageCount()->Int
    func getShareCount()->Int
    func getEyeCount()->Int
}



