import UIKit
import WebKit


class Wall_Cell_tp1: BaseWall {
    
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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    // like
    @IBOutlet weak var likeView: WallLike_View!
    
    
    // expand button
    @IBOutlet weak var expandButton: UIButton!
    
    // footer constraint
    @IBOutlet weak var footerHeightCon: NSLayoutConstraint!
    
    
    
    override func prepareForReuse() {
        reposterStackViewHeightCon.constant = 35
        authorStackViewHeightCon.constant = 35
        expandButton.isHidden = true
        prepareReuse()
    }
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return getPreferredLayoutAttributesFitting(layoutAttributes)
    }
    
    @IBAction func doPressImage(_ sender: Any) {
        guard let presenter = presenter else { return }
        baseWallVideo.pressImage(presenter: presenter, view: imageView, indexPath: indexPath, imageIdx: 0)
        presenter.selectImage(indexPath: indexPath, imageIdx: 0)
    }
    
    @IBAction func doExpand(_ sender: Any) {
        didPressExpand()
    }
    
    override func setupOutlets(){
        expandButton.isHidden = true
        // footer
        likeView.likeImageView.delegate = self
        likeView.message.delegate = self
        likeView.share.delegate = self
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
        return [imageView]
    }
    
    // footer
    override func getLikeView() -> WallLike_View {
        return likeView
    }
    
    
    override func getButtons() -> [UIButton]{
        return [imageButton]
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
    
    override func getFooterHeightCon() -> NSLayoutConstraint {
        return footerHeightCon
    }
}



