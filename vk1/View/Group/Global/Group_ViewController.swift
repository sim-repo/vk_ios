
import UIKit

class Group_ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    static let cellId = "Group_CollectionViewCell"
    static let cellPerRow: CGFloat = 1
    
    var presenter: PullPlainPresenterProtocol!
    
    var waiter: SpinnerViewController?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupLayout()
        setupStandardSearchController()
        UIControlThemeMgt.setupSearchControl(vc: self, searchController: searchController)
    }
    

    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
    }
    
    
    private func setupLayout(){
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2 - constraintSpaceX.constant*2) / Group_ViewController.cellPerRow
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Group_ViewController.cellId, for: indexPath) as! Group_CollectionViewCell
        
        guard let group = presenter.getData(indexPath: indexPath) as? Group
                   else {
                       catchError(msg: "Group_ViewController(): cellForItemAt(): presenter.getData is incorrected ")
                       return cell
               }
        cell.setup(group: group, presenter: presenter)
        return cell
    }
}


extension Group_ViewController : UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.viewDidFilterInput(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.viewDidFilterInput("")
    }
    
    private func setupStandardSearchController(){
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self

//        if let navigationbar = self.navigationController?.navigationBar {
//            navigationbar.setBackgroundImage(UIImage(), for: .default)
//            navigationbar.shadowImage = UIImage()
//            navigationbar.isTranslucent = true
//            self.navigationController?.view.backgroundColor = .clear
//        }
//        searchController.delegate = self
//        // cancel-button text color
//        searchController.searchBar.tintColor = .white
//        // white color input text
//        searchController.searchBar.barStyle = .default
//        // searchController.searchBar.barTintColor = .red
//        // handle press cancel-button
//        definesPresentationContext = true
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.dimsBackgroundDuringPresentation = false
//        // searchController.searchBar.searchBarStyle = .default
//        navigationItem.hidesSearchBarWhenScrolling = true
//        searchController.hidesNavigationBarDuringPresentation = false
//
//        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
//            if let backgroundview = textfield.subviews.first {
//                backgroundview.backgroundColor = UIColor.white
//                backgroundview.layer.cornerRadius = 15;
//                backgroundview.clipsToBounds = true;
//            }
//        }
    }
}



extension Group_ViewController: PushPlainViewProtocol{
    
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol?){}
    
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        self.collectionView.reloadData()
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?){
        waiter = SpinnerViewController(vc: self)
        waiter?.add(vcView: view)
    }
    
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?){
        waiter?.stop(vcView: view)
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {
        var indexes = [IndexPath]()
        for idx in startIdx...endIdx {
            let idx = IndexPath(row: idx, section: 0)
            indexes.append(idx)
        }
        
        collectionView.performBatchUpdates({ () -> Void in
            collectionView.insertItems(at: indexes)
        }, completion: nil)
    }
    
}
