
import UIKit

class Group_ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    var presenter = GroupPresenter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2 - constraintSpaceX.constant*2) / 1
        layout.itemSize = CGSize(width: width, height: 130)
    }
}





extension Group_ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Group_CollectionViewCell", for: indexPath) as! Group_CollectionViewCell
        cell.imageView.image = UIImage(named: presenter.getIcon(indexPath))
        cell.nameLabel.text = presenter.getName(indexPath)
        cell.descTextView.text = presenter.getDesc(indexPath)
        return cell
    }
    
    func getGroup(indexPath: IndexPath?) -> Group? {
        return presenter.getGroup(indexPath)
    }
}
