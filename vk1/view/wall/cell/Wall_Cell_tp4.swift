import UIKit

class Wall_Cell_tp4: UICollectionViewCell {
    @IBOutlet weak var title: UITextView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var likeView: WallLike_View!
}

extension Wall_Cell_tp4: Wall_CellProtocol {
    func setup(_ wall: WallProtocol) {
        let imageURLs = wall.getImageURLs()
        title.text = wall.getTitle()
        self.imageView1.image = UIImage(named: imageURLs[0])
        self.imageView2.image = UIImage(named: imageURLs[1])
        self.imageView3.image = UIImage(named: imageURLs[2])
        self.imageView4.image = UIImage(named: imageURLs[3])
        self.likeView.likeCount.text = "\(wall.getLikeCount())"
        self.likeView.messageCount.text = "\(wall.getMessageCount())"
        self.likeView.shareCount.text = "\(wall.getShareCount())"
        self.likeView.eyeCount.text = "\(wall.getEyeCount())"
        CommonElementDesigner.collectionCellBuilder(cell: self, title: nil)
    }
}
