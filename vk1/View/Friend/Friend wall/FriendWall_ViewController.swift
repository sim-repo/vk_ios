import UIKit

class FriendWall_ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    var presenter: PullPlainPresenterProtocol!
    var waiter: SpinnerViewController?
    var selectedImageIdx: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupCells()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.viewDidDisappear()
    }
    
    
    private func setupCells() {
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
                log("setupPresenter(): conformation exception", level: .error)
                return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let wall = sender as? Wall
            else { return }
        if let destinationView = segue.destination as? FriendPost_ViewController {
            if let idx = selectedImageIdx {
                destinationView.selectedImageIdx = idx
            }
            destinationView.wall = wall
        }
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        switch level {
        case .info:
            Logger.console(msg: "FriendWall_ViewController: " + msg, printEnum: .pagination)
        case .warning:
            Logger.catchWarning(msg: "FriendWall_ViewController: " + msg)
        case .error:
            Logger.catchError(msg: "FriendWall_ViewController: " + msg)
        }
    }
    
}

//MARK: - UICollectionViewDelegate

extension FriendWall_ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
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
        if let name = WallCellConstant.cellByCode[wall.postTypeCode] {
            cell = cellConfigure(name, indexPath, wall)
        }
        didScrollEnd(indexPath)
        return cell
    }
    
    private func getPullWallPresenterProtocol() -> PullWallPresenterProtocol? {
        return presenter as? PullWallPresenterProtocol
    }
    
    private func cellConfigure(_ cell: String, _ indexPath: IndexPath, _ wall: Wall) -> UICollectionViewCell{
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as! Wall_CellProtocol
        if let p = getPullWallPresenterProtocol() {
            c.setup(wall, indexPath, p, isExpanded: p.isExpandedCell(indexPath: indexPath), delegate: self)
        }
        return c
    }
    
    
    private func didScrollEnd(_ indexPath: IndexPath) {
        if indexPath.row >= presenter.numberOfRowsInSection() - NetworkConstant.remItemsToStartFetch {
            presenter.didEndScroll()
        }
    }
}


//MARK: - UIScrollViewDelegate

extension FriendWall_ViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let location = scrollView.panGestureRecognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location)
            else {
                log("scrollViewWillBeginDragging(): could not specify an indexpath", level: .error)
                return
        }
        didScrollEnd(indexPath)
    }
}



//MARK: - PushPlainViewProtocol

extension FriendWall_ViewController: PushPlainViewProtocol {
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol? = nil) {
        
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            guard let model_ = model else { return }
            self.performSegue(withIdentifier: segueId, sender: model_)
        }
    }
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
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

extension FriendWall_ViewController: PushWallViewProtocol {
    
    func playVideo(_ url: URL, _ platformEnum: WallCellConstant.VideoPlatform, _ indexPath: IndexPath) {
        //TODO: implement code here
    }
    
    
    func runPerformSegue(segueId: String, _ wall: WallModelProtocol, selectedImageIdx: Int) {
        self.selectedImageIdx = selectedImageIdx
        performSegue(withIdentifier: segueId, sender: wall)
    }
    
    func showError(_ indexPath: IndexPath, err: String) {
        //TODO: implement code here
    }
}




//MARK: - Expanded Cell

extension FriendWall_ViewController: WallCellProtocolDelegate {
    
    func didPressExpand(isExpand: Bool, indexPath: IndexPath) {
        if let presenter = getPullWallPresenterProtocol() {
            presenter.expandCell(isExpand: isExpand, indexPath: indexPath)
            UIView.animate(withDuration: 0.05, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                  self.collectionView.reloadItems(at: [indexPath])
                }, completion: nil)
        }
    }
}


extension FriendWall_ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        if let presenter = getPullWallPresenterProtocol() {
           
            let isExpanded = presenter.isExpandedCell(indexPath: indexPath)
            
            if isExpanded,
               let cell = collectionView.cellForItem(at: indexPath) as? Wall_CellProtocol,
               let attr = collectionView.layoutAttributesForItem(at: indexPath) {
                    cell.preferredLayoutAttributesFitting(attr)
                    return CGSize(width: width, height: cell.getPreferedHeight())
                }
            }
            return CGSize(width: width, height: WallCellConstant.cellHeight)
        }
}
