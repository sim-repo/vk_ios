import UIKit

class News_ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    var presenter: PullPlainPresenterProtocol!
    var waiter: SpinnerViewController?
    var selectedImageIdx: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupCells()
        UIControlThemeMgt.setupNavigationBarColor(navigationController: navigationController)
    }
    
    
    private func setupCells(){
        for i in 1...cellByCode.count {
            collectionView.register(UINib(nibName: cellByCode["tp\(i)"]!, bundle: nil), forCellWithReuseIdentifier: cellByCode["tp\(i)"]!)
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        let height = view.frame.size.height*0.3
        layout.minimumLineSpacing = 50
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
        guard  let _ = presenter as? PullWallPresenterProtocol
            else {
                log("setupPresenter(): conform exception", printEnum: nil, isErr: true)
                return
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let news = sender as? News
            else { return }
        if let destinationView = segue.destination as? NewsPost_ViewController {
            if let idx = selectedImageIdx {
                destinationView.selectedImageIdx = idx
            }
            destinationView.news = news
        }
    }
    
    
    private func log(_ msg: String, printEnum: PrintLogEnum?, isErr: Bool = false) {
        if isErr {
            catchError(msg: "News_ViewController(): "+msg)
        } else {
            if let printEnum_ = printEnum {
                console(msg: msg, printEnum: printEnum_)
            }
        }
    }
}


//MARK: - UICollectionViewDelegate

extension News_ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(presenter.numberOfRowsInSection())
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellByCode["tp1"]!, for: indexPath) // !
        
        guard let news = presenter.getData(indexPath: indexPath) as? News
            else {
                catchError(msg: "News_ViewController(): cellForItemAt(): presenter.getData is incorrected ")
                return cell
        }
        log("cellForItemAt(): idx: \(indexPath.row) - news.id: \(news.getId())", printEnum: .pagination)
        if let name = cellByCode[news.postTypeCode] {
            cell = cellConfigure(name, indexPath, news)
        }
        didScrollEnd(indexPath)
        return cell
    }
    
    private func getPullWallPresenterProtocol() -> PullWallPresenterProtocol? {
        return presenter as? PullWallPresenterProtocol
    }
    
    func cellConfigure(_ cell: String, _ indexPath: IndexPath, _ news: News) -> UICollectionViewCell{
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as! Wall_CellProtocol
        if let p = getPullWallPresenterProtocol() {
            c.setup(news, indexPath, p)
        }
        return c
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        return CGSize(width: width, height: cellHeaderHeight + cellImageHeight + cellBottomHeight)
    }
    
    private func didScrollEnd(_ indexPath: IndexPath) {
        log("didScrollEnd(): \(indexPath.row) >= \(presenter.numberOfRowsInSection() - Network.remItemsToStartFetch)", printEnum: .pagination)
        if indexPath.row >= presenter.numberOfRowsInSection() - Network.remItemsToStartFetch {
            presenter.didEndScroll()
        }
    }
}


//MARK: - UIScrollViewDelegate

extension News_ViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let location = scrollView.panGestureRecognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location)
            else {
                log("scrollViewWillBeginDragging(): could not specify an indexpath", printEnum: nil, isErr: true)
            return
        }
        didScrollEnd(indexPath)
    }
}


//MARK: - PushPlainViewProtocol

extension News_ViewController: PushPlainViewProtocol{
    
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol?){}
    
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        log("viewReloadData()", printEnum: .viewReloadData)
        collectionView.reloadData()
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?){
        waiter = SpinnerViewController(vc: self)
        waiter?.add(vcView: view)
    }
    
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?){
        waiter?.stop(vcView: view)
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {
        log("insertItems()", printEnum: .viewReloadData)
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


//MARK: - PushWallViewProtocol

extension News_ViewController: PushWallViewProtocol {
    
    func runPerformSegue(segueId: String, wall: WallModelProtocol, selectedImageIdx: Int) {
        self.selectedImageIdx = selectedImageIdx
        performSegue(withIdentifier: segueId, sender: wall)
    }
}

