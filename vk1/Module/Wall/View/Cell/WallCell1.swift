import UIKit
import WebKit


class WallCell1: BaseWall {
    
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
    
    @IBAction func doPressAuthor(_ sender: Any) {
        presenter?.didPressAuthor(indexPath: indexPath)
    }
    
    @IBAction func doPressImage(_ sender: Any) {
        guard let presenter = presenter else { return }
        baseWallVideo.pressImage(view: imageView)
        presenter.didSelectImage(indexPath: indexPath, imageIdx: 0)
    }
    
    @IBAction func doExpand(_ sender: Any) {
        didPressExpand()
    }
}


// MARK: - implementation ChildWallCellProtocol

extension WallCell1: ChildWallCellProtocol {
    
    func getImageContent() -> UIView {
        contentView
    }
    
    func setupOutlets(){
        expandButton.isHidden = true
        // footer
        likeView.likeImageView.delegate = self
        likeView.message.delegate = self
        likeView.share.delegate = self
    }
    
    func getButtons() -> [UIButton]{
        return [imageButton]
    }
    
    func getFooterHeightCon() -> NSLayoutConstraint {
        return footerHeightCon
    }
}

// MARK: - implementation WallCellProtocol

extension WallCell1: WallCellProtocol {
    
    // header constraints
    func getReposterHeightCon() -> NSLayoutConstraint {
        return reposterStackViewHeightCon
    }
    
    func getAuthorHeightCon() -> NSLayoutConstraint {
        return authorStackViewHeightCon
    }
    
    // reposter
    func getReposterName() -> UILabel {
        return reposterNameLabel
    }
    
    func getReposterDate() -> UILabel {
        return reposterDateLabel
    }
    
    func getReposterAva() -> UIImageView {
        return reposterAvaImageView
    }
    
    // author
    func getAuthorName() -> UILabel {
        return authorNameLabel
    }
    
    func getAuthorDate() -> UILabel {
        return authorDateLabel
    }
    
    func getAuthorAva() -> UIImageView  {
        return authorAvaImageView
    }
    
    // post message
    func getAuthorPostMsg() -> UILabel {
        return authorPostMsgLabel
    }
    
    // media
    func getImagesView() -> [UIImageView] {
        return [imageView]
    }
    
    // footer
    func getLikeView() -> WallLike_View {
        return likeView
    }
    
    func getExpandButton() -> UIButton {
        return expandButton
    }
    
    func getPreferedHeight() -> CGFloat {
        return preferedHeight
    }
    
    func getIndexRow() -> Int {
        return indexPath.row
    }
    
    func hideFooter() {
        getFooterHeightCon().constant = 0
        setNeedsLayout()
        layoutIfNeeded()
    }
}



