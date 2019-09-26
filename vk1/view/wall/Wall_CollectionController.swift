import UIKit


class Wall_CollectionController: UIViewController {

    var presenter = WallPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension Wall_CollectionController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        if let count = presenter.getImages(indexPath)?.count {
            switch count {
            case 1:
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "WallCollectionCell", for: indexPath) as! Wall_CollectionCell
                c.likeImageView.userActivityType = .like
                c.likeImageView.boundMetrics = c.likeCountLabel
                if let photo = presenter.getImages(indexPath) {
                    c.imageLabel.text = photo[0]
                }
                cell = c
            break;
            case _ where count == 2:
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "WallCollectionCell2", for: indexPath) as! Wall_CollectionCell2
                c.likeImageView.userActivityType = .like
                c.likeImageView.boundMetrics = c.likeCountLabel
                if let photos = presenter.getImages(indexPath) {
                    c.imageLabel.text = photos[0]
                    c.imageLabel2.text = photos[1]
                }
                cell = c
            break;
            case _ where count == 3:
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "WallCollectionCell3", for: indexPath) as! Wall_CollectionCell3
                c.likeImageView.userActivityType = .like
                c.likeImageView.boundMetrics = c.likeCountLabel
                if let photos = presenter.getImages(indexPath) {
                    c.imageLabel1.text = photos[0]
                    c.imageLabel2.text = photos[1]
                    c.imageLabel3.text = photos[2]
                }
                cell = c
                break;
            case _ where count == 4:
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "WallCollectionCell4", for: indexPath) as! Wall_CollectionCell4
                c.likeImageView.userActivityType = .like
                c.likeImageView.boundMetrics = c.likeCountLabel
                if let photos = presenter.getImages(indexPath) {
                    c.imageLabel1.text = photos[0]
                    c.imageLabel2.text = photos[1]
                    c.imageLabel3.text = photos[2]
                    c.imageLabel4.text = photos[3]
                }
                cell = c
                break;
            
            case _ where count == 5:
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "WallCollectionCell5", for: indexPath) as! Wall_CollectionCell5
                c.likeImageView.userActivityType = .like
                c.likeImageView.boundMetrics = c.likeCountLabel
                if let photos = presenter.getImages(indexPath) {
                    c.imageLabel1.text = photos[0]
                    c.imageLabel2.text = photos[1]
                    c.imageLabel3.text = photos[2]
                    c.imageLabel4.text = photos[3]
                    c.imageLabel5.text = photos[4]
                }
                cell = c
                break;
        
            default:
                let c = collectionView.dequeueReusableCell(withReuseIdentifier: "WallCollectionCell", for: indexPath) as! Wall_CollectionCell
                c.likeImageView.userActivityType = .like
                c.likeImageView.boundMetrics = c.likeCountLabel
                if let photo = presenter.getImages(indexPath) {
                    c.imageLabel.text = photo[0]
                }
                cell = c
            }
            
        }
    
        return cell
    }
    
    
}
