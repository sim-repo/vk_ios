import UIKit
import WebKit

class Wall_Cell_tp1_archive: UICollectionViewCell {
    
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var likeView: WallLike_View!
//    @IBOutlet weak var headerView: WallHeader_View!
//    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
//
//    @IBOutlet weak var imageButton: UIButton!
//
//    var presenter: PullWallPresenterProtocol?
//
//    var indexPath: IndexPath?
//
//    var webview: WKWebView? {
//        didSet {
//             webview?.navigationDelegate = self
//        }
//    }
//
//    var activityView: UIActivityIndicatorView?
//
//    override func prepareForReuse() {
//        imageView.image = UIImage(named: "placeholder")
//        webview?.removeFromSuperview()
//        webview = nil
//        activityView?.removeFromSuperview()
//        activityView = nil
//    }
//
//    @IBAction func doPressImage1(_ sender: Any) {
//        if let idx = indexPath {
//            presenter?.selectImage(indexPath: idx, imageIdx: 0)
//        }
//    }
//
//    func showActivityIndicatory() {
//        activityView = UIActivityIndicatorView(style: .large)
//        activityView?.center = self.contentView.center
//        self.contentView.addSubview(activityView!)
//        activityView?.startAnimating()
//    }
//}
//
//extension Wall_Cell_tp1: Wall_CellProtocol {
//
//    func setup(_ wall: WallModelProtocol, _ indexPath: IndexPath, _ presenter: PullWallPresenterProtocol) {
//        self.indexPath = indexPath
//        self.presenter = presenter
//        WallCellConfigurator.setupCell(cell: self, wall: wall)
//
//        if wall.getCellType() == .video {
//            let image = getSystemImage(name: "play.circle", pointSize: 50)
//            imageButton.setImage(image, for: .normal)
//        }
//
//        layoutIfNeeded()
//    }
//
//
//
//    func getImagesView() -> [UIImageView] {
//        return [imageView]
//    }
//
//    func getLikeView() -> WallLike_View {
//        return likeView
//    }
//
//    func getIndexRow() -> Int {
//        return indexPath?.row ?? 0
//    }
//
//    func getHeaderView() -> WallHeader_View {
//        return headerView
//    }
//
//    func getHConHeaderView() -> NSLayoutConstraint {
//        return hConHeaderView
//    }
//
//    func getWebView(config: WKWebViewConfiguration) -> WKWebView? {
//        webview = WKWebView(frame: bounds, configuration: config)
//        webview?.backgroundColor = .black
//        webview?.scrollView.backgroundColor = UIColor.clear
//        webview?.translatesAutoresizingMaskIntoConstraints = false
//
//        showActivityIndicatory()
//        return webview
//     }
//}
//
//
//extension Wall_Cell_tp1: WKNavigationDelegate {
//
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        addSubview(webview!)
//        activityView?.stopAnimating()
//        activityView?.removeFromSuperview()
//    }
//}

}
