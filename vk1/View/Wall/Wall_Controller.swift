import UIKit

class Wall_Controller: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    
    var presenter: PullPlainPresenterProtocol!
    var waiter: SpinnerViewController?
    
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
    }
}


extension Wall_Controller: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellByCode["tp1"]!, for: indexPath) // !
        
        guard let news = presenter.getData(indexPath: indexPath) as? News
            else {
                catchError(msg: "Wall_Controller(): cellForItemAt(): presenter.getData is incorrected ")
                return cell
        }
        
        if let name = cellByCode[news.postTypeCode] {
            cell = cellConfigure(name, indexPath, news)
        }
        didScrollEnd(indexPath)
        return cell
    }
    
    func cellConfigure(_ cell: String, _ indexPath: IndexPath, _ news: News) -> UICollectionViewCell{
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as! Wall_CellProtocol
        c.setup(news, indexRow: indexPath.row)
        return c
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - constraintSpaceX.constant * 40
        return CGSize(width: width, height: cellHeaderHeight + cellImageHeight + cellBottomHeight)
    }
    
    private func didScrollEnd(_ indexPath: IndexPath) {
        if indexPath.row == presenter.numberOfRowsInSection() - 1 {
            presenter.didEndScroll()
        }
    }
}


extension Wall_Controller: PushPlainViewProtocol{
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        console(msg: "Wall_Controller: viewReloadData()")
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
