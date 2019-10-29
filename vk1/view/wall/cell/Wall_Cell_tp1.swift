import UIKit

class Wall_Cell_tp1: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var headerView: WallHeader_View!
    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
    
    var indexRow: Int = 0
}

extension Wall_Cell_tp1: Wall_CellProtocol {
    
    func setup(_ wall: WallProtocol, indexRow: Int) {
        self.indexRow = indexRow
        WallCellConfigurator.setupCollectionCell(cell: self, wall: wall)
        layoutIfNeeded()
    }
    
    func getImagesView() -> [UIImageView] {
        return [imageView]
    }
    
    func getLikeView() -> WallLike_View {
        return likeView
    }
    
    func getIndexRow() -> Int {
        return indexRow
    }
    
    func getHeaderView() -> WallHeader_View {
        return headerView
    }
    
    func getHConHeaderView() -> NSLayoutConstraint {
        return hConHeaderView
    }
}

