import UIKit




class MyGroups_ViewController: UIViewController  {
    
    static let cellId = "MyGroup_CollectionViewCell"
    static let detailsSegueId = "MyGroupDetailSegue"
    static let groupSegueId = "GroupSegue"
    static let addGroupSegueId = "addGroupSegue"
    static let itemHeight:CGFloat = 130
    static let cellPerRow: CGFloat = 1
    
    
    var presenter = MyGroupPresenter()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2 - constraintSpaceX.constant*2) / MyGroups_ViewController.cellPerRow
        layout.itemSize = CGSize(width: width, height: MyGroups_ViewController.itemHeight)
        UIControlThemeMgt.setupNavigationBarColor(navigationController: navigationController)
    }
}





extension MyGroups_ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyGroups_ViewController.cellId, for: indexPath) as! MyGroup_CollectionViewCell
        cell.nameLabel.text = presenter.getName(indexPath)
        cell.descTextView?.text = presenter.getDesc(indexPath)
        cell.imageView.image = UIImage(named: presenter.getIcon(indexPath))
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        prepareDetailedSegue()
        performSegue(withIdentifier: MyGroups_ViewController.detailsSegueId, sender: indexPath)
    }
}


// MARK: segue handlers
extension MyGroups_ViewController {
    
    
    private func getNavigationController() -> CustomNavigationController {
        return navigationController as! CustomNavigationController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case MyGroups_ViewController.detailsSegueId:
                guard let indexPath = sender as? IndexPath,
                      let dest = segue.destination as? MyGroupDetail_ViewController
                else { return } // TODO: throw err
                dest.modalPresentationStyle = .custom
                dest.myGroup = presenter.getData(indexPath)
            default:
                return
        }
    }
    
    
    // MARK: segue: add group
    @IBAction func addGroupPressed(_ sender: Any) {
        prepareAddGroupSegue()
        performSegue(withIdentifier: MyGroups_ViewController.groupSegueId, sender: nil)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == MyGroups_ViewController.addGroupSegueId,
              let controller = segue.source as? Group_ViewController,
              let indexPath = controller.collectionView.indexPathsForSelectedItems,
              let selected = controller.getGroup(indexPath: indexPath[0])
        else { return }  // TODO: throw err

        if presenter.addGroup(group: selected) {
           let indexPath = presenter.getIndexPath()
           collectionView.insertItems(at: [indexPath])
        }
    }
    
    private func prepareAddGroupSegue(){
        getNavigationController().setup(pushAnimator: RotatedPushAnimator(), popAnimator: RotatedPopAnimator())
    }
    
    
    // MARK: segue: detailed group
    private func prepareDetailedSegue(){
        
        let navigationController = getNavigationController()
        let animator = ZoomAnimator()
        navigationController.setup(pushAnimator: animator, popAnimator: animator)
        
        guard
          let indexPath = collectionView.indexPathsForSelectedItems,
          let selectedCell = collectionView.cellForItem(at: indexPath[0])
          else { return }  // TODO: throw err
        
        guard let pushAnimator = navigationController.pushAnimator as? ZoomAnimator
            else { return } // TODO: throw err
        
        pushAnimator.prepareForPush(cell: selectedCell)
    }
}
