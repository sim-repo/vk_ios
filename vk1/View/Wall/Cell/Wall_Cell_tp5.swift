import UIKit
import WebKit


class Wall_Cell_tp5: BaseWall {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
    @IBOutlet weak var headerView: WallHeader_View!
    @IBOutlet weak var hConHeaderView: NSLayoutConstraint!
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var imageButton2: UIButton!
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var imageButton4: UIButton!
    @IBOutlet weak var imageButton5: UIButton!
    @IBOutlet weak var imageContentView: UIView!
    
    lazy var buttons = [imageButton1!,imageButton2!,imageButton3!,imageButton4!,imageButton5!]
    lazy var imageViews = [imageView1!,imageView2!,imageView3!,imageView4!,imageView5!]

    override func setupHeaderView(){
        let frame = headerView.origTitleTextView.frame
        presenter?.sendPostText(postText: frame )
        headerView.delegate = self
        headerView.prepare()
    }
    
    override func prepareForReuse() {
        prepareReuse()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return getPreferredLayoutAttributesFitting(layoutAttributes)
    }
    
    
    @IBAction func doPressImage1(_ sender: Any) {
       pressImage(imageIdx: 0)
    }
    
    @IBAction func doPressImage2(_ sender: Any) {
        pressImage(imageIdx: 1)
    }
    
    @IBAction func doPressImage3(_ sender: Any) {
        pressImage(imageIdx: 2)
    }
    
    @IBAction func doPressImage4(_ sender: Any) {
        pressImage(imageIdx: 3)
    }
    
    @IBAction func doPressImage5(_ sender: Any) {
        pressImage(imageIdx: 4)
    }
    
    // MARK: - implementation Wall_CellProtocol
    
     override func getImageContent() -> UIView {
         return imageContentView
     }
     
     override func getButtons() -> [UIButton]{
         return buttons
     }
     
     override func getPreferedHeight() -> CGFloat {
         return preferedHeight
     }
     
     override func getImagesView() -> [UIImageView] {
         return imageViews
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
