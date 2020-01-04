import UIKit
import WebKit


class Wall_Cell_tp1: BaseWall {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var headerView: WallHeader_View!
    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
    @IBOutlet weak var imageButton: UIButton!
    
    
    override func setupHeaderView(){
        let frame = headerView.origTitleTextView.frame
        presenter?.sendPostText(postText: frame )
        headerView.delegate = self
        headerView.prepare()
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeholder")
        baseWallVideo.prepareReuse(buttons: [imageButton])
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return getPreferredLayoutAttributesFitting(layoutAttributes)
    }
    
    @IBAction func doPressImage1(_ sender: Any) {
        guard let presenter = presenter else { return }
        baseWallVideo.pressImage(presenter: presenter, view: imageView, indexPath: indexPath, imageIdx: 0)
        presenter.selectImage(indexPath: indexPath, imageIdx: 0)
    }

    
    // MARK: - implementation Wall_CellProtocol

    override func getButtons() -> [UIButton]{
        return [imageButton]
    }
    
    override func getPreferedHeight() -> CGFloat {
        return preferedHeight
    }
    
    override func getImagesView() -> [UIImageView] {
        return [imageView]
    }
    
    override func getLikeView() -> WallLike_View {
        return likeView
    }
    
    override func getIndexRow() -> Int {
        return indexPath.row
    }
    
    override func getHeaderView() -> WallHeader_View {
        return headerView
    }
    
    override func getHConHeaderView() -> NSLayoutConstraint {
        return hConHeaderView
    }
}



