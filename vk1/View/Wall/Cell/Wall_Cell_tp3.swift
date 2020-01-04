import UIKit
import WebKit


class Wall_Cell_tp3: BaseWall {
    
    // header constraints
    @IBOutlet weak var reposterStackViewHeightCon: NSLayoutConstraint!
    @IBOutlet weak var authorStackViewHeightCon: NSLayoutConstraint!
    
    
    // reposter
    @IBOutlet weak var reposterNameLabel: UILabel!
    @IBOutlet weak var reposterDateLabel: UILabel!
    @IBOutlet weak var reposterAvaImageView: UIImageView!
    
    // author
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorDateLabel: UILabel!
    @IBOutlet weak var authorAvaImageView: UIImageView!
    
    // post message
    @IBOutlet weak var authorPostMsgLabel: UILabel!
    
    // media
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var imageButton2: UIButton!
    @IBOutlet weak var imageButton3: UIButton!
    
    @IBOutlet weak var likeView: WallLike_View!
    
    @IBOutlet weak var imageContentView: UIView!
    
    // expand button
    @IBOutlet weak var expandButton: UIButton!
    
    
    lazy var buttons = [imageButton1!,imageButton2!,imageButton3!]
    lazy var imageViews = [imageView1!,imageView2!,imageView3!]
    
    
    override func prepareForReuse() {
        reposterStackViewHeightCon.constant = 35
        authorStackViewHeightCon.constant = 35
        expandButton.isHidden = true
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
    
    @IBAction func doExpand(_ sender: Any) {
        didPressExpand()
    }
    
    override func setupOutlets(){
        expandButton.isHidden = true
    }
    
    // MARK: - implementation Wall_CellProtocol
    
    // header constraints
    override func getReposterHeightCon() -> NSLayoutConstraint {
        return reposterStackViewHeightCon
    }
    
    override func getAuthorHeightCon() -> NSLayoutConstraint {
        return authorStackViewHeightCon
    }
    
    // reposter
    override func getReposterName() -> UILabel {
        return reposterNameLabel
    }
    
    override func getReposterDate() -> UILabel {
        return reposterDateLabel
    }
    
    override func getReposterAva() -> UIImageView {
        return reposterAvaImageView
    }
    
    // author
    override func getAuthorName() -> UILabel {
        return authorNameLabel
    }
    
    override func getAuthorDate() -> UILabel {
        return authorDateLabel
    }
    
    override func getAuthorAva() -> UIImageView  {
        return authorAvaImageView
    }
    
    // post message
    override func getAuthorPostMsg() -> UILabel {
        return authorPostMsgLabel
    }
    
    // media
    override func getImagesView() -> [UIImageView] {
        return imageViews
    }
    
    // footer
    override func getLikeView() -> WallLike_View {
        return likeView
    }
    
    override func getImageContent() -> UIView {
        return imageContentView
    }
    
    override func getButtons() -> [UIButton]{
        return buttons
    }
    
    override func getExpandButton() -> UIButton {
        return expandButton
    }
    
    override func getPreferedHeight() -> CGFloat {
        return preferedHeight
    }
    
    override func getIndexRow() -> Int {
        return indexPath.row
    }
    
}
