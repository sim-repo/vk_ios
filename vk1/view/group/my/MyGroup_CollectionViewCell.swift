import UIKit
import Kingfisher

class MyGroup_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setup(group: MyGroup){
        
        UIControlThemeMgt.setupCollectionCell(cell: self, title: nameLabel)
        
        nameLabel.text = group.name
        descTextView?.text = group.desc
        imageView.kf.setImage(with: group.avaURL200)
    }
}
