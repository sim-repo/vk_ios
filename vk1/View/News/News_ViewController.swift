import UIKit
import WebKit


class News_ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    var presenter: PullPlainPresenterProtocol!
    var waiter: SpinnerViewController?
    var selectedImageIdx: Int?
    lazy var cellWidth = view.frame.size.width - constraintSpaceX.constant * 40
    
    // lesson 6
    var cellHeights = [IndexPath: CGFloat]() // for prevent "jumping" scrolling
    var notExpandedHeight : CGFloat = 500
    

    static let gallerySegueId = "NewsPostSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefresh()
        setupPresenter()
        setupCells()
        UIControlThemeMgt.setupNavigationBarColor(navigationController: navigationController)
    }
    
    
    private func setupCells(){
        for i in 1...WallCellConstant.cellByCode.count {
            collectionView.register(UINib(nibName: WallCellConstant.cellByCode["tp\(i)"]!, bundle: nil), forCellWithReuseIdentifier: WallCellConstant.cellByCode["tp\(i)"]!)
        }
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        layout.minimumLineSpacing = 50
        layout.itemSize = CGSize(width: width, height: 400)
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
        guard  let _ = presenter as? PullWallPresenterProtocol
            else {
                log("setupPresenter(): conformation exception", level: .error)
                return
        }
    }
    
    // lesson 7: refresh
    private func setupRefresh(){
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.attributedTitle = NSAttributedString(string: "refreshing..")
        collectionView.refreshControl?.tintColor = ColorSystemHelper.primary
        collectionView.refreshControl?.addTarget(self, action: #selector(doRefresh(sender:)), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
           case ModuleEnum.SegueIdEnum.comment.rawValue:
               guard let indexPath = sender as? IndexPath
               else {
                   Logger.catchError(msg: "NewsPost_ViewController: prepare(for segue:)")
                   return
               }
               segue.destination.modalPresentationStyle = .custom
               presenter.viewDidSeguePrepare(segueId: ModuleEnum.SegueIdEnum.comment, indexPath: indexPath)
        
        
            case News_ViewController.gallerySegueId:
               guard let news = sender as? News else { return }
               if let dest = segue.destination as? NewsPost_ViewController {
                   if let idx = selectedImageIdx {
                       dest.selectedImageIdx = idx
                   }
                   dest.news = news
               }
        
               default:
                   return
           }
    }
    
    //lesson 7: refresh
    @objc func doRefresh(sender: UIRefreshControl){
        collectionView.refreshControl?.beginRefreshing()
        let completion: (()->Void)? = { [weak self] in
            self?.collectionView.refreshControl?.endRefreshing() }
        presenter.tryRefresh(completion)
    }
    
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        SEQUENCE_THREAD {
            switch level {
            case .info:
                Logger.console(msg: "News_ViewController: " + msg, printEnum: .pagination)
            case .warning:
                Logger.catchWarning(msg: "News_ViewController: " + msg)
            case .error:
                Logger.catchError(msg: "News_ViewController: " + msg)
            }
        }
    }
}


//MARK: - UICollectionViewDelegate

extension News_ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // if comment out - occured to memory leak:
        //var cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallCellConstant.cellByCode["tp1"]!, for: indexPath) // !
        var cell: UICollectionViewCell!
        guard let news = presenter.getData(indexPath: indexPath) as? News
            else {
                log("cellForItemAt(): presenter.getData is incorrected ", level: .error)
                var cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallCellConstant.cellByCode["tp1"]!, for: indexPath)
                return cell
        }
        log("cellForItemAt(): idx: \(indexPath.row) - news.id: \(news.getId())", level: .info)
        if let cellId = WallCellConstant.cellByCode[news.imagesPlanCode] {
            cell = cellConfigure(cellId, indexPath, news)
        }
        
        didScrollEnd(indexPath)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // lesson 6
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    
    private func getPullWallPresenterProtocol() -> PullWallPresenterProtocol? {
        guard let _ = presenter as? PullWallPresenterProtocol
        else {
            log("getPullWallPresenterProtocol(): presenter must be conformed PullWallPresenterProtocol", level: .error)
            return nil
        }
        return presenter as? PullWallPresenterProtocol
    }
    
    func cellConfigure(_ cellId: String, _ indexPath: IndexPath, _ news: News) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! Wall_CellProtocol
        if let presenter = getPullWallPresenterProtocol() {
            let isExpanded = presenter.isExpandedCell(indexPath: indexPath)
            cell.setup(news, indexPath, presenter, isExpanded: isExpanded, delegate: self)
        }
        return cell
    }
    
    
    //lesson 7: pagination
    private func didScrollEnd(_ indexPath: IndexPath) {
        SEQUENCE_THREAD { [weak self] in
            guard let self = self else { return }
            self.log("didScrollEnd(): \(indexPath.row) >= \(self.presenter.numberOfRowsInSection() - NetworkConstant.remItemsToStartFetch)", level: .info)
            
            if indexPath.row >= self.presenter.numberOfRowsInSection() - NetworkConstant.remItemsToStartFetch {
                self.presenter.didEndScroll()
            }
        }
    }
}


//MARK: - UIScrollViewDelegate

extension News_ViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let location = scrollView.panGestureRecognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location)
            else {
                return
        }
        didScrollEnd(indexPath)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}


//MARK: - PushPlainViewProtocol

extension News_ViewController: PushPlainViewProtocol {

    
    func runPerformSegue(segueId: String, _ model: ModelProtocol?){
        guard let model = model
            else {
                log("runPerformSegue()", level: .warning)
                return }
        
        let indexPath = presenter?.getIndexPath(model: model)
        performSegue(withIdentifier: segueId, sender: indexPath)
    }
    
    func runPerformSegue(segueId: String, _ indexPath: IndexPath) {
        performSegue(withIdentifier: segueId, sender: indexPath)
    }
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        log("viewReloadData()", level: .info)
        PRESENTER_UI_THREAD { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?){
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.waiter = SpinnerViewController(vc: self)
            self.waiter?.add(vcView: self.view)
        }
    }
    
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?){
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.waiter?.stop(vcView: self.view)
        }
    }
    
    //lesson 7: pagination
    func insertItems(startIdx: Int, endIdx: Int) {
        log("insertItems()", level: .info)
        var indexes = [IndexPath]()
        for idx in startIdx...endIdx {
            let idx = IndexPath(row: idx, section: 0)
            indexes.append(idx)
        }
        PRESENTER_UI_THREAD { [weak self] in
                guard let self = self else { return }
                self.collectionView.performBatchUpdates({ () -> Void in
                self.collectionView.insertItems(at: indexes)
            }, completion: nil)
        }
    }
}


//MARK: - PushWallViewProtocol

extension News_ViewController: PushWallViewProtocol {
    
    func playVideo(_ url: URL, _ platformEnum: WallCellConstant.VideoPlatform, _ indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? Video_CellProtocol {
            cell.play(url: url, platformEnum: platformEnum)
        }
    }
    
    
    func runPerformSegue(segueId: String, _ wall: WallModelProtocol, selectedImageIdx: Int) {
        self.selectedImageIdx = selectedImageIdx
        performSegue(withIdentifier: segueId, sender: wall)
    }
    
    
    func showError(_ indexPath: IndexPath, err: String) {
        if let cell = collectionView.cellForItem(at: indexPath) as? Video_CellProtocol {
            cell.showErr(err: err)
        }
    }
}



//MARK: - Expanded Cell

extension News_ViewController: WallCellProtocolDelegate {
    
    //lesson 7: expand
    func didPressExpand(isExpand: Bool, indexPath: IndexPath) {
        if let presenter = getPullWallPresenterProtocol() {
            presenter.expandCell(isExpand: isExpand, indexPath: indexPath)
            UIView.animate(withDuration: 0.05, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.collectionView.reloadItems(at: [indexPath])
                }, completion: nil)
        }
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension News_ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let presenter = getPullWallPresenterProtocol() {
            let isExpanded = presenter.isExpandedCell(indexPath: indexPath)
            if isExpanded,
               let cell = collectionView.cellForItem(at: indexPath) as? Wall_CellProtocol,
               let attr = collectionView.layoutAttributesForItem(at: indexPath) {
                    cell.preferredLayoutAttributesFitting(attr)
                    return CGSize(width: cellWidth, height: cell.getPreferedHeight())
                }
            }

            // lesson 6
            let height = cellHeights[indexPath]
            return CGSize(width: cellWidth, height: height ?? notExpandedHeight)
        }
}
