import UIKit
import Kingfisher

class Wall_Cell_tp2: UICollectionViewCell {
    @IBOutlet weak var title: UITextView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var conHeightTitle: NSLayoutConstraint!
    var indexRow: Int = 0
}

extension Wall_Cell_tp2: Wall_CellProtocol {
    
    func setup(_ wall: WallProtocol, indexRow: Int) {
        self.indexRow = indexRow
        WallCellConfigurator.setupCollectionCell(cell: self, wall: wall)
        layoutIfNeeded()
    }
    
    
    func getTitle() -> UITextView {
        return title
    }
    
    func getImagesView() -> [UIImageView] {
        return [imageView1, imageView2]
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
