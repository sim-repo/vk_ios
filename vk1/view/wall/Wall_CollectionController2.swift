import UIKit



class Wall_CollectionController2: UIViewController {
    
    var presenter = WallPresenter()
    
    @IBOutlet weak var collectionView: UICollectionView!
    static let cellId = "Wall_Cell2"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "Wall_CollectionCell", bundle: nil), forCellWithReuseIdentifier: Wall_CollectionController2.cellId)
        collectionView.reloadData()
    }
}


extension Wall_CollectionController2: UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Wall_CollectionController2.cellId, for: indexPath) as! Wall_CollectionCell
        cell.imagesSetup(presenter: presenter, indexPath: indexPath)
        cell.likeImageView.userActivityType = .like
        cell.likeImageView.boundMetrics = cell.likeNumber
        cell.imageViews.forEach({$0.userActivityType = .look})
        return cell
    }
}

