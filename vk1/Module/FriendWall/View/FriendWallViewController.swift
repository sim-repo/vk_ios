import UIKit

class FriendWallViewController: UIViewController, Storyboarded {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    private var presenter: ViewableWallPresenterProtocol!
    var waiter: SpinnerViewController?
    var selectedImageIdx: Int?
    
    lazy var cellWidth = view.frame.size.width - constraintSpaceX.constant * 40
    var cellHeights = [IndexPath: CGFloat]() // for prevent "jumping" scrolling
    var notExpandedHeight : CGFloat = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPresenter()
        setupCells()
    }
    
    private func checkPresenter() {
        if presenter == nil {
            fatalError("FriendWallViewController: checkPresenter(): presenter is nil")
        }
    }
    
    private func setupCells() {
        for i in 1...WallCellConstant.maxImagesInCell {
            let id = WallCellConstant.getId(imageCount: i)
            collectionView.register(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        let height = view.frame.size.height*0.3
        layout.minimumLineSpacing = 50
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "FriendWallViewController", msg, level: level, printEnum: .pagination)
    }
}



//MARK: - UICollectionViewDelegate

extension FriendWallViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        guard let wall = presenter.getData(indexPath: indexPath) as? Wall
            else { return UICollectionViewCell() }
   
        let cellName = WallCellConstant.getId(imageCount: wall.imageURLs.count)
        cell = cellConfigure(cellName, indexPath, wall)
        didScrollEnd(indexPath)
        return cell
    }
    
    private func cellConfigure(_ cell: String, _ indexPath: IndexPath, _ wall: Wall) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as! WallCellProtocol
        cell.setup(wall, indexPath, presenter, isExpanded: presenter.isExpandedCell(indexPath: indexPath), delegate: self)
        return cell
    }
    
    private func didScrollEnd(_ indexPath: IndexPath) {
        if indexPath.row >= presenter.numberOfRowsInSection() - NetworkConstant.remItemsToStartFetch {
            presenter.didEndScroll()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
}


//MARK: - UIScrollViewDelegate

extension FriendWallViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let location = scrollView.panGestureRecognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location)
            else {
                log("scrollViewWillBeginDragging(): could not specify an indexpath", level: .error)
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


//MARK:- PresentablePlainViewProtocol

extension FriendWallViewController: PresentablePlainViewProtocol {
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.collectionView?.reloadData()
        }
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {
        log("insertItems()", level: .info)
        var indexes = [IndexPath]()
        for idx in startIdx...endIdx {
           let idx = IndexPath(row: idx, section: 0)
           indexes.append(idx)
        }

        UI_THREAD { [weak self] in
           guard let self = self else { return }
           self.collectionView.performBatchUpdates({ () -> Void in
               self.collectionView.insertItems(at: indexes)
           }, completion: nil)
        }
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?) {
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.waiter = SpinnerViewController(vc: self)
            self.waiter?.add(vcView: self.view)
        }
    }
    
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?) {
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.waiter?.stop(vcView: self.view)
        }
    }
}



//MARK: - PresentableWallViewProtocol

extension FriendWallViewController: PresentableWallViewProtocol {
    
    func playVideo(_ url: URL, _ platformEnum: WallCellConstant.VideoPlatform, _ indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoableWallCellProtocol {
            cell.play(url: url, platformEnum: platformEnum)
        }
    }
    
    func showVideoError(_ indexPath: IndexPath, err: String) {
        if let cell = collectionView.cellForItem(at: indexPath) as? VideoableWallCellProtocol {
            cell.showErr(err: err)
        }
    }
}


//MARK: - WallCellProtocolDelegate

extension FriendWallViewController: WallCellProtocolDelegate {
    
    func didPressExpand(isExpand: Bool, indexPath: IndexPath) {
        presenter.didPressExpandCell(isExpand: isExpand, indexPath: indexPath)
        
        UIView.animate(withDuration: 0.05, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
              self.collectionView.reloadItems(at: [indexPath])
            }, completion: nil)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension FriendWallViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let isExpanded = presenter.isExpandedCell(indexPath: indexPath)
        if isExpanded,
           let cell = collectionView.cellForItem(at: indexPath) as? WallCellProtocol,
           let attr = collectionView.layoutAttributesForItem(at: indexPath) {
                cell.preferredLayoutAttributesFitting(attr)
                return CGSize(width: cellWidth, height: cell.getPreferedHeight())
            }
        let height = cellHeights[indexPath]
        return CGSize(width: cellWidth, height: height ?? notExpandedHeight)
    }
}


//MARK:- CoordinatableViewProtocol

extension FriendWallViewController: CoordinatableViewProtocol {
    func setPresenter(_ presenter: ViewablePresenterProtocol) {
        self.presenter = presenter as! ViewableWallPresenterProtocol
    }
}
