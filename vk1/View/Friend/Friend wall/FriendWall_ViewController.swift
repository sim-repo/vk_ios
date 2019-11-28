import UIKit

class FriendWall_ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    var presenter: PullPlainPresenterProtocol!
    
    var waiter: SpinnerViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        
        for i in 1...cellByCode.count {
            collectionView.register(UINib(nibName: cellByCode["tp\(i)"]!, bundle: nil), forCellWithReuseIdentifier: cellByCode["tp\(i)"]!)
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        let height = view.frame.size.height*0.3
        layout.minimumLineSpacing = 50
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.viewDidDisappear()
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
        guard  let _ = presenter as? PullWallPresenterProtocol
            else {
                log("setupPresenter(): conform exception", isErr: true)
                return
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        guard let wall = sender as? Wall
            else { return }
        if let destinationView = segue.destination as? FriendPost_ViewController {
            destinationView.wall = wall
        }
    }
    
    private func log(_ msg: String, isErr: Bool = false) {
        if isErr {
            catchError(msg: "FriendWall_ViewController(): "+msg)
        } else {
            console(msg: msg, printEnum: .viewReloadData)
        }
    }
}


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
        if let name = cellByCode[wall.postTypeCode] {
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
        return CGSize(width: width, height: cellHeaderHeight + cellImageHeight + cellBottomHeight)
    }
    
    
    private func didScrollEnd(_ indexPath: IndexPath) {
        if indexPath.row >= presenter.numberOfRowsInSection() - 5 {
            presenter.didEndScroll()
        }
    }
}


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
        log("FriendWall_ViewController(): insertItems()")
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


