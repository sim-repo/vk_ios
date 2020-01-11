import UIKit

class Likes_TableViewCell: UITableViewCell {

    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var onlineView: MyView_Circled!
    
    weak var like: Like?
    
    static func clazz() -> String {
        return String(describing: Likes_TableViewCell.self)
    }
    
    static func id() -> String {
        return String(describing: Likes_TableViewCell.self)
    }

    func setup(like: Like){
        self.like = like
        nameLabel.text = like.firstName + " " + like.lastName
        cityLabel.text = like.city
        avaImageView.kf.setImage(with: like.avaURL100)
        let online = like.online
        onlineView.backgroundColor = online ? ColorSystemHelper.secondary : #colorLiteral(red: 1, green: 0, blue: 0.2314973176, alpha: 1)
    }
    
    func setAva(url: URL){
        avaImageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        avaImageView.image = UIImage(named: "placeholder")
        nameLabel.text = ""
        cityLabel.text = ""
        like = nil
    }
}
