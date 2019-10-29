import UIKit

class WallLike_View : UIView{
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var likeImageView: PostImageView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var message: PostImageView!
    @IBOutlet weak var messageCount: UILabel!
    @IBOutlet weak var eye: PostImageView!
    @IBOutlet weak var eyeCount: UILabel!
    @IBOutlet weak var share: PostImageView!
    @IBOutlet weak var shareCount: UILabel!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("WallLike_View", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        UIControlThemeMgt.setupLikeControl(like: likeImageView, likeCount: likeCount, message: message, eye: eye, share: share, messageCount: messageCount, eyeCount: eyeCount, shareCount: shareCount)
    }
}
