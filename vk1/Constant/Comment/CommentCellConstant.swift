import Foundation


class CommentCellConstant {
    
    static func getCellIdentifier(imageCount: Int) -> String {
        switch imageCount {
            case 0: return "CommentCellText"
            case 1: return "CommentCellImage"
            case 2: return "CommentCell2xImage"
            default:
                return "CommentCellImage"
        }
    }
    
    
    static func getCellIdentifier2(imageCount: Int) -> String {
        switch imageCount {
            case 0: return NewsCommentUser_TableViewCell.id()
            default:
                return NewsCommentUser_TableViewCell.id()
        }
    }
}
