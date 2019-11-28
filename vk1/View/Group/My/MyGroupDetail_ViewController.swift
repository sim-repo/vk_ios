import UIKit
import Kingfisher

class MyGroupDetail_ViewController: UIViewController {
    
    @IBOutlet weak var constraintSpaceX: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var conHeightHeader: NSLayoutConstraint!
    
    //header view:
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var descTextView: UITextView!
    
    @IBOutlet var constraintLogoHeight: NSLayoutConstraint!
    @IBOutlet var constraintDescHeight: NSLayoutConstraint!
    @IBOutlet var constraintCoverHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintCounterHeight: NSLayoutConstraint!
    @IBOutlet weak var counterLabel: UILabel!
    
    var presenter: PullPlainPresenterProtocol!
    var scrollViewLastContentOffset: CGFloat = 0
    var headerViewIsHide = false
    lazy var waiter: SpinnerViewController = SpinnerViewController(vc: self)
    
    var headerViewOriginalHeight: CGFloat = 0
    var logoOriginalHeight: CGFloat = 0
    var descOriginalHeight: CGFloat = 0
    var coverOriginalHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupCells()
        navigationItem.title = "Waiting for networking.."
        headerViewOriginalHeight = conHeightHeader.constant
        logoOriginalHeight = constraintLogoHeight.constant
        descOriginalHeight = constraintDescHeight.constant
        coverOriginalHeight = constraintCoverHeight.constant
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
    
    private func setupCells(){
        for i in 1...cellByCode.count {
            collectionView.register(UINib(nibName: cellByCode["tp\(i)"]!, bundle: nil), forCellWithReuseIdentifier: cellByCode["tp\(i)"]!)
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 50
        layout.itemSize = CGSize(width: 100, height: 300)
    }
    
    private func log(_ msg: String, isErr: Bool = false) {
        if isErr {
            catchError(msg: "MyGroupDetail_ViewController(): "+msg)
        } else {
            console(msg: msg, printEnum: .viewReloadData)
        }
    }
}

// MARK: collection delegate
extension MyGroupDetail_ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let subPresenter = presenter.getSubPlainPresenter() {
            return subPresenter.numberOfRowsInSection()
        } else {
            catchError(msg: "MyGroupDetail_ViewController: numberOfItemsInSection: child presenter in not initialized")
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellByCode["tp1"]!, for: indexPath) // !
        
        guard let subPresenter = presenter.getSubPlainPresenter()
            else {
                catchError(msg: "MyGroupDetail_ViewController: cellForItemAt: child presenter in not initialized")
                return cell
        }
        
        guard let wall = subPresenter.getData(indexPath: indexPath) as? Wall
            else {
                catchError(msg: "MyGroupDetail_ViewController: cellForItemAt: no data")
                return cell
        }
        
        if let name = cellByCode[wall.postTypeCode] {
            cell = cellConfigure(name, indexPath, wall)
        }
        return cell
    }
    
    private func getPullWallPresenterProtocol() -> PullWallPresenterProtocol? {
        return presenter as? PullWallPresenterProtocol
    }
    
    func cellConfigure(_ cell: String, _ indexPath: IndexPath, _ wall: Wall) -> UICollectionViewCell{
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as! Wall_CellProtocol
        if let p = getPullWallPresenterProtocol() {
            c.setup(wall, indexPath, p)
        }
        return c
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - constraintSpaceX.constant * 10
        return CGSize(width: width, height: cellHeaderHeight + cellImageHeight + cellBottomHeight)
    }
}


extension MyGroupDetail_ViewController: PushPlainViewProtocol{
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol?) {
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?) {
        
        if moduleEnum == .my_group_detail {
            waiter.add(vcView: headerView)
        }
        if moduleEnum == .my_group_wall {
            waiter.add(vcView: collectionView)
        }
    }
    
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?) {
        
        if moduleEnum == .my_group_detail {
            waiter.stop(vcView: headerView)
        }
        
        if moduleEnum == .my_group_wall {
            waiter.stop(vcView: collectionView)
        }
    }
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        
        // MyGroup Detail:
        if moduleEnum == .my_group_detail {
            
            guard let group = presenter.getData(indexPath: nil) as? DetailGroup
                else { catchError(msg: "MyGroupDetail_ViewController: setup(): datasource is null" )
                    return
            }
            navigationItem.title = group.name
            if group.coverURL400 == nil {
                coverImageView.kf.setImage(with: group.avaURL200)
            } else {
                logoImageView.kf.setImage(with: group.avaURL200)
                coverImageView.kf.setImage(with: group.coverURL400)
            }
            
            
            descTextView?.text = group.desc
            //resize UITEXTVIEW:
            descOriginalHeight = descTextView.actualSize().height
            constraintDescHeight.constant = descOriginalHeight
            
            
            let str = "[members]: " + group.membersCount.toString() +
                "\n[photos]: " + group.photosCounter.toString() +
                "\n[albums]: " + group.albumsCounter.toString() +
                "\n[topics]: " + group.topicsCounter.toString() +
                "\n[videos]: " + group.videosCounter.toString() +
                "\n[market]: " + group.marketCounter.toString() +
                "\n[closed]: " + group.isClosed.toString() +
                "\n[deactivated]: " + group.isDeactivated.toString()
            
            
            //resize UILABEL:
            counterLabel.text = str // set
            counterLabel.sizeToFit()
            constraintCounterHeight.constant = counterLabel.frame.size.height
            counterLabel.text = "" // reset
            counterLabel.setTextWithTypeAnimation(typedText: str, characterDelay: 10)
            
            //resize UIVIEW:
            headerViewOriginalHeight = self.constraintDescHeight.constant + constraintCounterHeight.constant + constraintCoverHeight.constant + 16
            conHeightHeader.constant = headerViewOriginalHeight
            
            stopWaitIndicator(moduleEnum)
        }
        
        // MyGroup Wall:
        if moduleEnum == .my_group_wall {
            if presenter.getSubPlainPresenter()!.numberOfRowsInSection() > 0 {
                stopWaitIndicator(moduleEnum)
                collectionView.reloadData()
            }
        }
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {}
    
}


extension MyGroupDetail_ViewController: UIScrollViewDelegate {
    
    @IBAction func didPressHamburger(_ sender: Any) {
        headerViewAppearence(hide: !headerViewIsHide)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewLastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard headerViewIsHide == false
            else { return }
        
        if scrollViewLastContentOffset + 50 < scrollView.contentOffset.y {
            headerViewAppearence(hide: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    private func headerViewAppearence(hide: Bool) {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let self = self else { return }
            self.conHeightHeader.constant = hide ? 0 : self.headerViewOriginalHeight
            self.constraintLogoHeight.constant = hide ? 0 : self.logoOriginalHeight
            self.constraintDescHeight.constant = hide ? 0 :  self.descOriginalHeight
            self.constraintCoverHeight.constant = hide ? 0 :  self.coverOriginalHeight
            
            self.headerView.alpha = hide ? 0 : 1
            self.view.layoutIfNeeded()
            self.headerViewIsHide = hide
        })
    }
}
