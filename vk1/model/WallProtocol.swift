import Foundation

protocol WallProtocol {
    func getImageURLs()->[String]
    func getTitle()->String?
    func getLikeCount()->Int
    func getMessageCount()->Int
    func getShareCount()->Int
    func getEyeCount()->Int
}



