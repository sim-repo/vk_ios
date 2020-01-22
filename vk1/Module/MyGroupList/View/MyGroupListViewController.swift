import UIKit

class MyGroupListViewController: UIViewController, Storyboarded  {
    
    @IBOutlet weak var lettersSearchControl: LettersSearchControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    var presenter: ViewableSectionPresenterProtocol!
    static let cellId = "MyGroup_CollectionViewCell"
    static let detailSegueId = "MyGroupDetailSegue"
    static let groupSegueId = "GroupSegue"
    static let addGroupSegueId = "addGroupSegue"
    var waiter: SpinnerViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPresenter()
        setupAlphabetSearchControl()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2 - constraintSpaceX.constant*2)
        layout.itemSize = CGSize(width: width, height: 130)
        UIControlThemeMgt.setupNavigationBarColor(navigationController: navigationController)
    }
    
    
    private func checkPresenter() {
        if presenter == nil {
            fatalError("MyGroupViewControllers: checkPresenter(): presenter is nil")
        }
        let _ = presenter as! ViewableTransitionPresenterProtocol
    }
    
    private func setupAlphabetSearchControl(){
        lettersSearchControl.delegate = self
        lettersSearchControl.updateControl(with: presenter?.getGroupBy())
    }
}


extension MyGroupListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myGroupSectionHeader", for: indexPath) as! GroupSectionHeader
        view.title = presenter.getSectionTitle(section: indexPath.section)
        view.count = String(presenter.numberOfRowsInSection(section: indexPath.section))
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGroupListCell", for: indexPath) as! MyGroupCollectionViewCell
        
        guard let data = presenter.getData(indexPath: indexPath)
               else {
                   return UICollectionViewCell()
                }
        let group = data as! MyGroup
        cell.setup(group: group)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (presenter as! ViewableTransitionPresenterProtocol).didPressTransition(to: .myGroupDetail, selectedIndexPath: indexPath)
    }
}


extension MyGroupListViewController: AlphabetSearchViewControlProtocol {
    
    func didEndTouch() {}
    
    func didChange(indexPath: IndexPath) {
       collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    func getView() -> UIView {
        return self.view
    }
}

