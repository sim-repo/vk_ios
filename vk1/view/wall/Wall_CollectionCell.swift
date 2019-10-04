import UIKit

class Wall_CollectionCell: UICollectionViewCell {
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var likeImageView: UserActivityRegControl!
    @IBOutlet weak var likeNumber: UILabel!
    
    var imageViews: [UserActivityRegControl] = []
    
    func imagesSetup(presenter: WallPresenter, indexPath: IndexPath){
        guard let photos = presenter.getImages(indexPath)
            else { return }
        
        guard photos.count > 0
            else { return }
        ImageCellConfigurator.configure(parentView: myView, photoURLs: photos, imageViews: &imageViews)
    }
}
