import UIKit
import WebKit


class Wall_Cell_tp1: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var headerView: WallHeader_View!
    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
    
    @IBOutlet weak var imageButton: UIButton!
    
    var presenter: PullWallPresenterProtocol?
    
    var indexPath: IndexPath?
    
    var videoWebView: VideoWebViewMgt?
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeholder")
        shouldShowPlayButton(isShow: false)
        videoWebView?.prepareForReuse()
    }
    
    @IBAction func doPressImage1(_ sender: Any) {
        if let idx = indexPath {
            videoWebView?.startActivityIndicator()
            presenter?.selectImage(indexPath: idx, imageIdx: 0)
        }
    }
    
    func shouldShowPlayButton(isShow: Bool){
        if isShow {
            let image = getSystemImage(name: "play.circle", pointSize: 50)
            imageButton.setImage(image, for: .normal)
        } else {
            imageButton.setImage(.none, for: .normal)
        }
        layoutIfNeeded()
    }
}

extension Wall_Cell_tp1: Wall_CellProtocol {
    
    func setup(_ wall: WallModelProtocol, _ indexPath: IndexPath, _ presenter: PullWallPresenterProtocol) {
        self.indexPath = indexPath
        self.presenter = presenter
        WallCellConfigurator.setupCell(cell: self, wall: wall)
        
        if wall.getCellType() == .video {
            videoWebView = VideoWebViewMgt()
            videoWebView?.setup(webviewContent: imageView)
            shouldShowPlayButton(isShow: true)
        }
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

extension Wall_Cell_tp1: Video_CellProtocol {
    
    func play(url: URL, platformEnum: WallCellConstant.VideoPlatform) {
        shouldShowPlayButton(isShow: false)

        self.videoWebView?.playVideo(url: url, platformEnum: platformEnum) {[weak self] in
            self?.shouldShowPlayButton(isShow: true)
        }
    }
}

