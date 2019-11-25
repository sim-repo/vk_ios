import UIKit
import Kingfisher


class Group_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var groupId: String?
    var presenter: PullPlainPresenterProtocol?
    func setup(group: Group, presenter: PullPlainPresenterProtocol){
        UIControlThemeMgt.setupCollectionCell(cell: self, title: nameLabel)
        self.presenter = presenter
        imageView?.kf.setImage(with: group.avaURL200)
        nameLabel.text = group.name
        descTextView.text = group.desc
        groupId = String(group.id)
    }
    
    @IBAction func joinGroup(_ sender: Any) {
        (presenter as? GroupPresenter)?.joinGroup(groupId: groupId!)
    }
}
