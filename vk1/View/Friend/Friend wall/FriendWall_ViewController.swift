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
                log("setupPresenter(): conform exception", printEnum: nil, isErr: true)
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
    
    private func log(_ msg: String, printEnum: PrintLogEnum?, isErr: Bool = false) {
        if isErr {
            catchError(msg: "FriendWall_ViewController(): "+msg)
        } else {
            if let printEnum_ = printEnum {
                console(msg: msg, printEnum: printEnum_)
            }
        }
    }
    
}

//MARK: - UICollectionViewDelegate

extension FriendWall_ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
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
            c.setup(wall, indexPath, p)
        }
        return c
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        return CGSize(width: width, height: WallCellConstant.headerHeight + WallCellConstant.imageHeight + WallCellConstant.footerHeight)
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
                log("scrollViewWillBeginDragging(): could not specify an indexpath", printEnum: nil, isErr: true)
                return
        }
        didScrollEnd(indexPath)
    }
}



//MARK: - PushPlainViewProtocol

extension FriendWall_ViewController: PushPlainViewProtocol {
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol? = nil) {
        guard let model_ = model else { return }
        performSegue(withIdentifier: segueId, sender: model_)
    }
    
    func viewReloadData(moduleEnum: ModuleEnum) {
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

extension FriendWall_ViewController: PushWallViewProtocol {
    
    func runPerformSegue(segueId: String, wall: WallModelProtocol, selectedImageIdx: Int) {
        self.selectedImageIdx = selectedImageIdx
        performSegue(withIdentifier: segueId, sender: wall)
    }
}

