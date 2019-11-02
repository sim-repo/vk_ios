import UIKit

class Wall_Cell_tp6: UICollectionViewCell {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var headerView: WallHeader_View!
    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
    var indexRow: Int = 0
}

extension Wall_Cell_tp6: Wall_CellProtocol {
    
    
    func setup(_ wall: WallProtocol, indexRow: Int) {
        self.indexRow = indexRow
        WallCellConfigurator.setupCell(cell: self, wall: wall)
        layoutIfNeeded()
    }
       
    func getImagesView() -> [UIImageView] {
       return [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6]
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
