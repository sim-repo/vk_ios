import UIKit
import Kingfisher

class Wall_Cell_tp1: UICollectionViewCell {
    @IBOutlet weak var title: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var conHeightTitle: NSLayoutConstraint!
    var indexRow: Int = 0
}

extension Wall_Cell_tp1: Wall_CellProtocol {
    
    func setup(_ wall: WallProtocol, indexRow: Int) {
        self.indexRow = indexRow
        
        if let wall = wall as? Wall {
            //TODO
        } else
        if let friendWall = wall as? FriendWall {
            //TODO
        }
        WallCellConfigurator.setupCollectionCell(cell: self, wall: wall)
        layoutIfNeeded()
    }
    
    func getTitle() -> UITextView {
        return title
    }
    
    func getImagesView() -> [UIImageView] {
        return [imageView]
    }
    
    func getLikeView() -> WallLike_View {
        return likeView
    }
    
    func getConstraintTitleHeight() -> NSLayoutConstraint {
        return conHeightTitle
    }
    
    func getIndexRow() -> Int {
        return indexRow
    }
}

