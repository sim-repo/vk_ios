import UIKit

class Wall_Controller: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    var presenter = WallPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...UIControlThemeMgt.cellByCode.count {
            collectionView.register(UINib(nibName: UIControlThemeMgt.cellByCode["tp\(i)"]!, bundle: nil), forCellWithReuseIdentifier: UIControlThemeMgt.cellByCode["tp\(i)"]!)
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        let height = view.frame.size.height*0.5
        layout.minimumLineSpacing = 50
        layout.itemSize = CGSize(width: width, height: height)
        UIControlThemeMgt.setupNavigationBarColor(navigationController: navigationController)
    }
}


extension Wall_Controller: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        let wall = presenter.getData(indexPath)!
        if let name = UIControlThemeMgt.cellByCode[wall.postTypeCode] {
            cell = cellConfigure(name, indexPath, wall)
        }
        return cell
    }
    
    func cellConfigure(_ cell: String, _ indexPath: IndexPath, _ wall: Wall) -> UICollectionViewCell{
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as! Wall_CellProtocol
        c.setup(wall)
        return c
    }
}
