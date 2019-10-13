import UIKit

class Group_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setup(){
        UIControlThemeMgt.setupCollectionCell(cell: self, title: nameLabel)
    }
}
