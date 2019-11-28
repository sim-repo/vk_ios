import UIKit

class Wall_Cell_tp2: UICollectionViewCell {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var headerView: WallHeader_View!
    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
    var indexPath: IndexPath!
    var presenter: PullWallPresenterProtocol!
    
    @IBAction func doPressImage1(_ sender: Any) {
       presenter.selectImage(indexPath: indexPath, imageIdx: 0)
    }
    
    @IBAction func doPressImage2(_ sender: Any) {
        presenter.selectImage(indexPath: indexPath, imageIdx: 1)
    }
}

extension Wall_Cell_tp2: Wall_CellProtocol {
    
    func setup(_ wall: WallModelProtocol, _ indexPath: IndexPath, _ presenter: PullWallPresenterProtocol) {
        self.indexPath = indexPath
        self.presenter = presenter
        WallCellConfigurator.setupCell(cell: self, wall: wall)
        layoutIfNeeded()
    }
    
    func getImagesView() -> [UIImageView] {
        return [imageView1, imageView2]
    }
    
    func getLikeView() -> WallLike_View {
        return likeView
    }
    
    func getIndexRow() -> Int {
        return indexPath.row
    }
    
    func getHeaderView() -> WallHeader_View {
        return headerView
    }
    
    func getHConHeaderView() -> NSLayoutConstraint {
        return hConHeaderView
    }
}
