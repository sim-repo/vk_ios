import UIKit

class Wall_Cell_tp1: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var headerView: WallHeader_View!
    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
    
    var presenter: PullWallPresenterProtocol?
    
    var indexPath: IndexPath?
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeholder")
    }
    
    @IBAction func doPressImage1(_ sender: Any) {
        if let idx = indexPath {
            presenter?.selectImage(indexPath: idx, imageIdx: 0)
        }
    }
}

extension Wall_Cell_tp1: Wall_CellProtocol {
    
    func setup(_ wall: WallModelProtocol, _ indexPath: IndexPath, _ presenter: PullWallPresenterProtocol) {
        self.indexPath = indexPath
        self.presenter = presenter
        WallCellConfigurator.setupCell(cell: self, wall: wall)
        layoutIfNeeded()
    }
    
    func getImagesView() -> [UIImageView] {
        return [imageView]
    }
    
    func getLikeView() -> WallLike_View {
        return likeView
    }
    
    func getIndexRow() -> Int {
        return indexPath?.row ?? 0
    }
    
    func getHeaderView() -> WallHeader_View {
        return headerView
    }
    
    func getHConHeaderView() -> NSLayoutConstraint {
        return hConHeaderView
    }
}

