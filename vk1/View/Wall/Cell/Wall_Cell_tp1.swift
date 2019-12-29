import UIKit
import WebKit


class Wall_Cell_tp1: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var headerView: WallHeader_View!
    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
    @IBOutlet weak var imageButton: UIButton!
    
    var presenter: PullWallPresenterProtocol!
    var indexPath: IndexPath!
    var cellType: WallCellConstant.CellTypeEnum!
    var preferedHeight: CGFloat = WallCellConstant.cellHeight
    var isExpanded = false
    var delegate: WallCellProtocolDelegate?
    var wall: WallModelProtocol!
    var baseWallVideo: BaseWallVideo = BaseWallVideo()
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeholder")
        baseWallVideo.prepareReuse(buttons: [imageButton])
    }
    
    @IBAction func doPressImage1(_ sender: Any) {
        baseWallVideo.pressImage(presenter: presenter, view: imageView, indexPath: indexPath, imageIdx: 0)
        presenter?.selectImage(indexPath: indexPath, imageIdx: 0)
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



extension Wall_Cell_tp1: Wall_CellProtocol {
    
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
        headerView.prepare()
        
        WallCellConfigurator.setupCell(cell: self, wall: wall, isExpanded: isExpanded)
        
        cellType = wall.getCellType()
        if wall.getCellType() == .video {
            baseWallVideo.setup(buttons: [imageButton])
        }
    }
    
    func getPreferedHeight() -> CGFloat {
        return preferedHeight
    }
    
    func getImagesView() -> [UIImageView] {
        return [imageView]
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

extension Wall_Cell_tp1: Video_CellProtocol {
    
    func play(url: URL, platformEnum: WallCellConstant.VideoPlatform) {
        baseWallVideo.play(url: url, platformEnum: platformEnum)
    }
    
    func showErr(err: String) {
        baseWallVideo.showErr(err: err)
    }
}

extension Wall_Cell_tp1: WallHeaderProtocolDelegate {
    func didPressExpand() {
        isExpanded = !isExpanded
        WallCellConfigurator.expandCell(cell: self, wall: wall, isExpanded: isExpanded)
        delegate?.didPressExpand(isExpand: isExpanded, indexPath: indexPath)
    }
}
