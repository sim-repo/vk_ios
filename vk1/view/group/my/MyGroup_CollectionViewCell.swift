import UIKit

class MyGroup_CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setup(){
        CommonElementDesigner.collectionCellBuilder(cell: self, title: nameLabel)
    }
}