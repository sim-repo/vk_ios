import UIKit

class MyGroup_ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter = MyGroupPresenter()
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2 - constraintSpaceX.constant*2) / 1
        layout.itemSize = CGSize(width: width, height: 130)
        CommonElementDesigner.setupNavigationBarColor(navigationController: navigationController)
    }
}



extension MyGroup_ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGroup_CollectionViewCell", for: indexPath) as! MyGroup_CollectionViewCell
        cell.nameLabel.text = presenter.getName(indexPath)
        cell.descTextView?.text = presenter.getDesc(indexPath)
        cell.imageView.image = UIImage(named: presenter.getIcon(indexPath))
         return cell
    }
    
    @IBAction func addGroupPressed(_ sender: Any) {
        performSegue(withIdentifier: "GroupSegue", sender: nil)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroupSegue",
        let controller = segue.source as? Group_ViewController {
            if let indexPath = controller.collectionView.indexPathsForSelectedItems,
               let selected = controller.getGroup(indexPath: indexPath[0]) {
                if presenter.addGroup(group: selected) {
                    let indexPath = presenter.getIndexPath()
                    collectionView.insertItems(at: [indexPath])
                }
            }
        }
    }

}
