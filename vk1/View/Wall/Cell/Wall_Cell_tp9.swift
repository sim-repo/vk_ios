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
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var imageButton2: UIButton!
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var imageButton4: UIButton!
    @IBOutlet weak var imageButton5: UIButton!
    @IBOutlet weak var imageButton6: UIButton!
    @IBOutlet weak var imageButton7: UIButton!
    @IBOutlet weak var imageButton9: UIButton!
    @IBOutlet weak var imageButton8: UIButton!
    
    @IBOutlet weak var imageContentView: UIView!
    
    var indexPath: IndexPath!
    var presenter: PullWallPresenterProtocol!
    var isExpanded = false
    var delegate: WallCellProtocolDelegate?
    var preferedHeight: CGFloat = WallCellConstant.cellHeight
    var wall: WallModelProtocol!
    var cellType: WallCellConstant.CellTypeEnum!
    var videoService: VideoWebViewService?
    
    @IBAction func doPressImage1(_ sender: Any) {
        pressImage(imageContentView, 0)
    }
    
    @IBAction func doPressImage2(_ sender: Any) {
        pressImage(imageContentView, 1)
    }
    
    @IBAction func doPressImage3(_ sender: Any) {
        pressImage(imageContentView, 2)
    }
    
    @IBAction func doPressImage4(_ sender: Any) {
        pressImage(imageContentView, 3)
    }
    
    @IBAction func doPressImage5(_ sender: Any) {
        pressImage(imageContentView, 4)
    }
    
    @IBAction func doPressImage6(_ sender: Any) {
        pressImage(imageContentView, 5)
    }
    
    @IBAction func doPressImage7(_ sender: Any) {
        pressImage(imageContentView, 6)
    }
    
    @IBAction func doPressImage8(_ sender: Any) {
        pressImage(imageContentView, 7)
    }
    
    @IBAction func doPressImage9(_ sender: Any) {
        pressImage(imageContentView, 8)
    }
    
    private func pressImage(_ view: UIView, _ imageIdx: Int) {
        if cellType == .video {
           videoService = VideoWebViewService()
           videoService?.setup(webviewContent: view)
           videoService?.startActivityIndicator()
        }
        presenter.selectImage(indexPath: indexPath, imageIdx: imageIdx)
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
    
    override func prepareForReuse() {
        imageView1.image = UIImage(named: "placeholder")
        shouldShowPlayButton(isShow: false)
        videoService?.prepareForReuse()
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
        headerView.prepare()
        
        cellType = wall.getCellType()
        if cellType == .video {
            shouldShowPlayButton(isShow: true)
        }
        
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
    
    func shouldShowPlayButton(isShow: Bool){
        if isShow {
            let image = getSystemImage(name: "play.circle", pointSize: 50)
            imageButton1.setImage(image, for: .normal)
            imageButton2.setImage(image, for: .normal)
            imageButton3.setImage(image, for: .normal)
            imageButton4.setImage(image, for: .normal)
            imageButton5.setImage(image, for: .normal)
            imageButton6.setImage(image, for: .normal)
            imageButton7.setImage(image, for: .normal)
            imageButton8.setImage(image, for: .normal)
            imageButton9.setImage(image, for: .normal)
        } else {
            imageButton1.setImage(.none, for: .normal)
            imageButton2.setImage(.none, for: .normal)
            imageButton3.setImage(.none, for: .normal)
            imageButton4.setImage(.none, for: .normal)
            imageButton5.setImage(.none, for: .normal)
            imageButton6.setImage(.none, for: .normal)
            imageButton7.setImage(.none, for: .normal)
            imageButton8.setImage(.none, for: .normal)
            imageButton9.setImage(.none, for: .normal)
        }
        layoutIfNeeded()
    }
}


extension Wall_Cell_tp9: Video_CellProtocol {
    
    func play(url: URL, platformEnum: WallCellConstant.VideoPlatform) {
        shouldShowPlayButton(isShow: false)

        self.videoService?.playVideo(url: url, platformEnum: platformEnum) {[weak self] in
            guard let self = self else { return }
            if self.cellType == .video {
                self.shouldShowPlayButton(isShow: true)
            }
        }
    }
    
    func showErr(err: String) {
        PRESENTER_UI_THREAD {
            let image = getSystemImage(name: "exclamationmark.icloud", pointSize: 50)
            self.imageButton1.setImage(image, for: .normal)
            self.videoService?.stopActivityIndicator()
            self.videoService = nil
        }
    }
}

extension Wall_Cell_tp9: WallHeaderProtocolDelegate {
    func didPressExpand() {
        isExpanded = !isExpanded
        WallCellConfigurator.expandCell(cell: self, wall: wall, isExpanded: isExpanded)
        delegate?.didPressExpand(isExpand: isExpanded, indexPath: indexPath)
    }
}
