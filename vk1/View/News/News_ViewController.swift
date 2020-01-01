import UIKit
import WebKit


class News_ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    var presenter: PullPlainPresenterProtocol!
    var waiter: SpinnerViewController?
    var selectedImageIdx: Int?
    lazy var cellWidth = view.frame.size.width - constraintSpaceX.constant * 40
    var cellHeights = [IndexPath: CGFloat]() // for prevent "jumping" scrolling
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let height = view.frame.size.height*0.3
        layout.minimumLineSpacing = 50
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
        guard  let _ = presenter as? PullWallPresenterProtocol
            else {
                log("setupPresenter(): conform exception", level: .error)
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
                return cell
        }
        log("cellForItemAt(): idx: \(indexPath.row) - news.id: \(news.getId())", level: .info)
        if let name = WallCellConstant.cellByCode[news.imagesPlanCode] {
            cell = cellConfigure(name, indexPath, news)
        }
        
        didScrollEnd(indexPath)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    
    private func getPullWallPresenterProtocol() -> PullWallPresenterProtocol? {
        return presenter as? PullWallPresenterProtocol
    }
    
    func cellConfigure(_ cell: String, _ indexPath: IndexPath, _ news: News) -> UICollectionViewCell{
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as! Wall_CellProtocol
        if let p = getPullWallPresenterProtocol() {
            c.setup(news, indexPath, p, isExpanded: p.isExpandedCell(indexPath: indexPath), delegate: self)
            p.disableExpanding(indexPath: indexPath)
        }
        return c
    }
    
    
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

extension News_ViewController: PushPlainViewProtocol{
    
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol?){}
    
    
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
    
    func didPressExpand(isExpand: Bool, indexPath: IndexPath) {
        if let presenter = getPullWallPresenterProtocol() {
            presenter.expandCell(isExpand: isExpand, indexPath: indexPath)
            UIView.animate(withDuration: 0.05, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.collectionView.reloadItems(at: [indexPath])
                    self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                }, completion: nil)
        }
    }
}


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
        
            let height = cellHeights[indexPath]
            return CGSize(width: cellWidth, height: height ?? WallCellConstant.cellHeight)
        }
}
