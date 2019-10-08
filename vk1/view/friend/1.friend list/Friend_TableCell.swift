import UIKit

class Friend_TableCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avaImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
