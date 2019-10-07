import UIKit

class Wall_Cell_tp1: UICollectionViewCell {
    @IBOutlet weak var title: UITextView!
    @IBOutlet weak var imageView: UIImageView!
}

extension Wall_Cell_tp1: Wall_CellProtocol {
    
    func setup(_ wall: WallProtocol) {
        if let wall = wall as? Wall {
            //TODO
        } else
        if let friendWall = wall as? FriendWall {
            //TODO
        }
        title.text = wall.getTitle()
        let imageURLs = wall.getImageURLs()
        self.imageView.image = UIImage(named: imageURLs[0])
    }
}

