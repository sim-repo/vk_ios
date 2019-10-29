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
        
        if let urlStr = group.avaURL200 {
            let url = URL(string: urlStr)
            imageView.kf.setImage(with: url)
        }
    }
}
