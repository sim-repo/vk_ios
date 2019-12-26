import UIKit
import WebKit

class Wall_Cell_tp9: UICollectionViewCell {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var imageView7: UIImageView!
    @IBOutlet weak var imageView8: UIImageView!
    @IBOutlet weak var imageView9: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var headerView: WallHeader_View!
    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
    var indexPath: IndexPath!
    var presenter: PullWallPresenterProtocol!
    var isExpanded = false
    var delegate: WallCellProtocolDelegate?
    var preferedHeight: CGFloat = WallCellConstant.cellHeight
    var wall: WallModelProtocol!
    
    @IBAction func doPressImage1(_ sender: Any) {
       presenter.selectImage(indexPath: indexPath, imageIdx: 0)
    }
    
    @IBAction func doPressImage2(_ sender: Any) {
        presenter.selectImage(indexPath: indexPath, imageIdx: 1)
    }
    
    @IBAction func doPressImage3(_ sender: Any) {
        presenter.selectImage(indexPath: indexPath, imageIdx: 2)
    }
    
    @IBAction func doPressImage4(_ sender: Any) {
        presenter.selectImage(indexPath: indexPath, imageIdx: 3)
    }
    
    @IBAction func doPressImage5(_ sender: Any) {
        presenter.selectImage(indexPath: indexPath, imageIdx: 4)
    }
    
    @IBAction func doPressImage6(_ sender: Any) {
        presenter.selectImage(indexPath: indexPath, imageIdx: 5)
    }
    
    @IBAction func doPressImage7(_ sender: Any) {
        presenter.selectImage(indexPath: indexPath, imageIdx: 6)
    }
    
    @IBAction func doPressImage8(_ sender: Any) {
        presenter.selectImage(indexPath: indexPath, imageIdx: 7)
    }
    
    @IBAction func doPressImage9(_ sender: Any) {
        presenter.selectImage(indexPath: indexPath, imageIdx: 8)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        setNeedsLayout()
    
        let preferredLayoutAttributes = layoutAttributes
        
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = preferredLayoutAttributes.size.width
        let size = systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        var adjustedFrame = preferredLayoutAttributes.frame
        adjustedFrame.size.height = ceil(size.height)
        preferredLayoutAttributes.frame = adjustedFrame
        preferedHeight = adjustedFrame.size.height
        return preferredLayoutAttributes
    }
}

extension Wall_Cell_tp9: Wall_CellProtocol {
    
    
    func setup(_ wall: WallModelProtocol,
               _ indexPath: IndexPath,
               _ presenter: PullWallPresenterProtocol,
               isExpanded: Bool,
               delegate: WallCellProtocolDelegate) {
        
        self.indexPath = indexPath
        self.presenter = presenter
        self.isExpanded = isExpanded
        self.wall = wall
        self.delegate = delegate
        headerView.delegate = self
        
        WallCellConfigurator.setupCell(cell: self, wall: wall, isExpanded: isExpanded)
        layoutIfNeeded()
    }
    
    func getPreferedHeight() -> CGFloat {
        return preferedHeight
    }
       
    func getImagesView() -> [UIImageView] {
       return [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7, imageView8, imageView9]
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


extension Wall_Cell_tp9: WallHeaderProtocolDelegate {
    func didPressExpand() {
        isExpanded = !isExpanded
        WallCellConfigurator.expandCell(cell: self, wall: wall, isExpanded: isExpanded)
        delegate?.didPressExpand(isExpand: isExpanded, indexPath: indexPath)
    }
}
