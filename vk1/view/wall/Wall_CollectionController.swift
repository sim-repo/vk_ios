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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallCollectionCell", for: indexPath) as! Wall_CollectionCell
        cell.likeImageView.userActivityType = .like
        cell.likeImageView.boundMetrics = cell.likeCountLabel
        return cell
    }
    
    
}
