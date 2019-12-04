import UIKit

protocol WallModelProtocol{
    
    // wall header block
    func getMyName() -> String?
    func getMyAvaURL() -> URL?
    func getMyPostDate() -> Double
    func getTitle() -> String?
    
    func getOrigName() -> String?
    func getOrigAvaURL() -> URL?
    func getOrigPostDate() -> Double
    func getOrigTitle() -> String?
    
    // wall media block
    func getImageURLs() -> [URL]
    func getCellType() -> WallCellConstant.CellTypeEnum
    
    
    // wall bottom block
    func getLikeCount() -> Int
    func getMessageCount() -> Int
    func getShareCount() -> Int
    func getEyeCount() -> Int
}



