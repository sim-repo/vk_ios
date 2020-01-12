import UIKit

class NewsCommentTop_TableViewCell: UITableViewCell {

    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var expandingButton: UIButton!
    @IBOutlet weak var showLikesButton: UIButton!
    
    
    var wall: WallModelProtocol?
    var delegate: NewsComment_ViewController?
    
    override func prepareForReuse() {
        avaImageView.image = UIImage(named: "placeholder")
        photoImageView.image = UIImage(named: "placeholder")
        nameLabel.text = ""
        dateLabel.text = ""
        titleLabel.text = ""
        showLikesButton.setTitle("", for: .normal)
    }
    
    static func clazz() -> String {
        return String(describing: NewsCommentTop_TableViewCell.self)
    }
    
    static func id() -> String {
        return String(describing: NewsCommentTop_TableViewCell.self)
    }
    
    func setup(_ wall: WallModelProtocol, _ isExpanded: Bool) {
        avaImageView.kf.setImage(with: wall.getOrigAvaURL())
        nameLabel.text = wall.getOrigName()
        dateLabel.text = convertUnixTime(unixTime: wall.getOrigPostDate())
        if let msg = wall.getOrigTitle() {
            titleLabel.text = isExpanded ? msg : String(msg.prefix(160))
        }
        let URLs = wall.getImageURLs()
        photoImageView.kf.setImage(with: URLs[0])
        self.wall = wall
        expandingButton.isHidden = isExpanded
        showLikesButton.setTitle("Понравилось \(wall.getLikeCount()) людям", for: .normal)
    }
    
    @IBAction func doExpand(_ sender: Any) {
        titleLabel.text = wall?.getOrigTitle()
        expandingButton.isHidden = true
        delegate?.didPressExpand()
    }
    
    
    @IBAction func doShowLikes(_ sender: Any) {
        delegate?.didPressShowLikes()
    }
    
}

