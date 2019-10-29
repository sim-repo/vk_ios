import UIKit
import Kingfisher

class Friend_TableCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avaImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(friend: Friend) {
        name?.text = friend.firstName + " " + friend.lastName
        if let urlStr = friend.avaURL50 {
            let url = URL(string: urlStr)
            avaImage?.kf.setImage(with: url)
        }
    }
}
