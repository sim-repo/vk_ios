import UIKit




class MyGroups_ViewController: UIViewController  {
    
    var presenter: SectionedPresenterProtocol!
    
    static let cellId = "MyGroup_CollectionViewCell"
    static let detailsSegueId = "MyGroupDetailSegue"
    static let groupSegueId = "GroupSegue"
    static let addGroupSegueId = "addGroupSegue"
    static let itemHeight:CGFloat = 130
    static let cellPerRow: CGFloat = 1
    
    @IBOutlet weak var lettersSearchControl: LettersSearchControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupAlphabetSearchControl()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2 - constraintSpaceX.constant*2) / MyGroups_ViewController.cellPerRow
        layout.itemSize = CGSize(width: width, height: MyGroups_ViewController.itemHeight)
        UIControlThemeMgt.setupNavigationBarColor(navigationController: navigationController)
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getSectioned(vc: self)
    }
    
    private func setupAlphabetSearchControl(){
        lettersSearchControl.delegate = self
        lettersSearchControl.updateControl(with: presenter.getGroupingProperties())
    }
}


extension MyGroups_ViewController: AlphabetSearchViewControlProtocol {
    func didEndTouch() {
        // TODO
    }
    
    func didChange(indexPath: IndexPath) {
       collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    func getView() -> UIView {
        return self.view
    }
}



extension MyGroups_ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       // print("viewForSupplementaryElementOfKind")
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myGroupSectionHeader", for: indexPath) as! GroupSectionHeader
        view.title = presenter.sectionName(section: indexPath.section)
        view.count = String(presenter.numberOfRowsInSection(section: indexPath.section))
        return view
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyGroups_ViewController.cellId, for: indexPath) as! MyGroup_CollectionViewCell
        
        guard let data = presenter.getData(indexPath: indexPath)
               else {
                   return UICollectionViewCell()
                }
        let group = data as! MyGroup
        cell.setup(group: group)
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
        
        guard let presenter = presenter as? MyGroupPresenter
          else {
              //TODO: throw err
              return
          }
            
        switch segue.identifier {
            case MyGroups_ViewController.detailsSegueId:
                guard let indexPath = sender as? IndexPath,
                      let dest = segue.destination as? MyGroupDetail_ViewController
                else { return } // TODO: throw err
                dest.modalPresentationStyle = .custom
                dest.myGroup = presenter.getData(indexPath: indexPath) as? MyGroup
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
        guard let presenter = presenter as? MyGroupPresenter
                 else {
                     //TODO: throw err
                     return
                 }
        
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



extension MyGroups_ViewController: ViewProtocol{
     
    func refreshDataSource(){
        presenter.refreshDataSource(){ [weak self] (titles) in
            self?.lettersSearchControl.updateControl(with: titles)
            self?.collectionView.reloadData()
        }
    }
    
    func className() -> String {
         return String(describing: MyGroups_ViewController.self)
     }
    
    func optimReloadCell(indexPath: IndexPath) {
       collectionView.reloadItems(at: [indexPath])
    }
}
