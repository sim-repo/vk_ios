import UIKit





class WallHeader_View : UIView{
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var hConRepostAuthorContentView: NSLayoutConstraint!
    @IBOutlet weak var hConOrigAuthorContentView: NSLayoutConstraint!
    
    @IBOutlet weak var hConRepostTitleTextView: NSLayoutConstraint!
    @IBOutlet weak var hConOrigTitleTextView: NSLayoutConstraint!
    
    @IBOutlet weak var hConExpandingButton: NSLayoutConstraint!
    @IBOutlet weak var myAvaImageView: UIImageView!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myPostDateLabel: UILabel!
    @IBOutlet weak var myTitleTextView: UITextView!
    
    
    @IBOutlet weak var origAvaImageView: UIImageView!
    @IBOutlet weak var origNameLabel: UILabel!
    @IBOutlet weak var origPostDateLabel: UILabel!
    @IBOutlet weak var origTitleTextView: UITextView!
    
    @IBOutlet weak var expandedButton: UIButton!
    
    var delegate: WallHeaderProtocolDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed("WallHeader_View", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        expandedButton.setTitle("", for: .normal)
    }
    
    @IBAction func pressExpandedButton(_ sender: Any) {
        expandedButton.setTitle("", for: .normal)
        layoutIfNeeded()
        delegate?.didPressExpand()
    }
    
    public func addExpandedButton(expanded: Bool){
        expandedButton.setTitle(expanded ? "" : "Показать полностью...", for: .normal)
        hConExpandingButton.constant = 20
        layoutIfNeeded()
    }
    
    public func prepare(){
        expandedButton.setTitle("", for: .normal)
        hConExpandingButton.constant = 0
    }
}
