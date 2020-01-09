import UIKit

struct WallCellConstant {

    static let headerHeight: CGFloat = 30
    static let quarterHeight: CGFloat =  120 / 4
    static let mediaBlockHeight: CGFloat = 280
    static let footerHeight: CGFloat = 30
    static let cellHeight: CGFloat = headerHeight + mediaBlockHeight + footerHeight
    
    enum CellTypeEnum: String {
        case post = "post"
        case wall_photo = "wall_photo"
        case video = "video"
        case audio = "audio"
        case unknown = "unknown"
    }
    
    enum VideoPlatform: String {
        case youtube = "YouTube"
        case other = "other"
        case null = "null"
    }
    
    static let  cellByCode = ["tp1": "Wall_Cell_tp1",
                             "tp2": "Wall_Cell_tp2",
                             "tp3": "Wall_Cell_tp3",
                             "tp4": "Wall_Cell_tp4",
                             "tp5": "Wall_Cell_tp5",
                             "tp6": "Wall_Cell_tp6",
                             "tp7": "Wall_Cell_tp7",
                             "tp8": "Wall_Cell_tp8",
                             "tp9": "Wall_Cell_tp9"]
    
    
    static func getImagePlanCode(imageCount: Int) -> String {
        switch imageCount {
            case 1: return "tp1"
            case 2: return "tp2"
            case 3: return "tp3"
            case 4: return "tp4"
            case 5: return "tp5"
            case 6: return "tp6"
            case 7: return "tp7"
            case 8: return "tp8"
            case 9: return "tp9"
            default:
                return "tp9"
        }
    }
}
