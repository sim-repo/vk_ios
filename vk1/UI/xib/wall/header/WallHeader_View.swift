import UIKit

class WallHeader_View : UIView{
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var hConRepostAuthorContentView: NSLayoutConstraint!
    @IBOutlet var hConOrigAuthorContentView: NSLayoutConstraint!
    
    @IBOutlet var hConRepostTitleTextView: NSLayoutConstraint!
    @IBOutlet var hConOrigTitleTextView: NSLayoutConstraint!
    
    @IBOutlet var myAvaImageView: UIImageView!
    @IBOutlet var myNameLabel: UILabel!
    @IBOutlet var myPostDateLabel: UILabel!
    @IBOutlet var myTitleTextView: UITextView!
    
    
    @IBOutlet var origAvaImageView: UIImageView!
    @IBOutlet var origNameLabel: UILabel!
    @IBOutlet var origPostDateLabel: UILabel!
    @IBOutlet var origTitleTextView: UITextView!
    
    
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       commonInit()
    }

    private func commonInit(){
       Bundle.main.loadNibNamed("WallHeader_View", owner: self, options: nil)
       addSubview(contentView)
       contentView.frame = self.bounds
       contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
