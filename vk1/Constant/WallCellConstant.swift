import UIKit

struct WallCellConstant {

    static let minMediaBlockHeight: CGFloat = 280
    static let maxMediaBlockHeight: CGFloat = 400
    
    static let maxImagesInCell = 9
    
    enum CellEnum: String {
        case post,wall_photo,video,audio,unknown
    }
    
    enum VideoPlatform: String {
        case youtube, other, null
    }
    
    static func getId(imageCount: Int) -> String {
       let cnt = min(maxImagesInCell, imageCount)
       return "WallCell\(cnt)"
    }
}
