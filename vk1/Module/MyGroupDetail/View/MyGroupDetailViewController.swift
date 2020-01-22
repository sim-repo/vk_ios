import UIKit

class MyGroupDetailViewController: UIViewController, Storyboarded  {
    
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
    
    var presenter: ViewableMyGroupDetailPresenterProtocol!
    var scrollViewLastContentOffset: CGFloat = 0
    var headerViewIsHide = false
    lazy var waiter: SpinnerViewController = SpinnerViewController(vc: self)
    
    var headerViewOriginalHeight: CGFloat = 0
    var logoOriginalHeight: CGFloat = 0
    var descOriginalHeight: CGFloat = 0
    var coverOriginalHeight: CGFloat = 0
    lazy var cellWidth = view.frame.size.width - constraintSpaceX.constant * 40
    var cellHeights = [IndexPath: CGFloat]() // for prevent "jumping" scrolling
    var notExpandedHeight : CGFloat = 500
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPresenter()
        setupCells()
        navigationItem.title = "Waiting for networking.."
        headerViewOriginalHeight = conHeightHeader.constant
        logoOriginalHeight = constraintLogoHeight.constant
        descOriginalHeight = constraintDescHeight.constant
        coverOriginalHeight = constraintCoverHeight.constant
    }
    
    private func checkPresenter() {
        if presenter == nil {
            fatalError("MyGroupDetailViewController: checkPresenter(): presenter is nil")
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
        Logger.log(clazz: "MyGroupDetailViewController", msg, level: level, printEnum: .pagination)
    }
}


// MARK: collection delegate
extension MyGroupDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getMyGroupWallPresenter().numberOfRowsInSection()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallCellConstant.getId(imageCount: 1), for: indexPath)
        
        guard let wall = presenter.getMyGroupWallPresenter().getData(indexPath: indexPath) as? Wall
            else {
                log("cellForItemAt: no data", level: .error)
                return cell
        }
        
        let name = WallCellConstant.getId(imageCount: wall.imageURLs.count)
        cell = cellConfigure(name, indexPath, wall)
        return cell
    }
    
    func cellConfigure(_ cellName: String, _ indexPath: IndexPath, _ wall: Wall) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! WallCellProtocol
        let sub = presenter.getMyGroupWallPresenter()
        cell.setup(wall, indexPath, sub, isExpanded: sub.isExpandedCell(indexPath: indexPath), delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
}


//MARK: - ViewablePlainPresenterProtocol
extension MyGroupDetailViewController: PresentablePlainViewProtocol {
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            // MyGroup Detail:
            if moduleEnum == .myGroupDetail {
                
                guard let group = self.presenter.getData(indexPath: nil) as? MyGroupDetail
                    else {
                        self.log("setup(): datasource is null", level: .error)
                        return }
                self.navigationItem.title = group.myGroup?.name
                if group.myGroup?.coverURL400 == nil {
                    self.coverImageView.kf.setImage(with: group.myGroup?.avaURL200)
                } else {
                    self.logoImageView.kf.setImage(with: group.myGroup?.avaURL200)
                    self.coverImageView.kf.setImage(with: group.coverURL400)
                }
                
                
                self.descTextView?.text = group.myGroup?.desc
                //resize UITEXTVIEW:
                self.descOriginalHeight = self.descTextView.actualSize().height
                self.constraintDescHeight.constant = self.descOriginalHeight
                
                var str = ""
                if let g = group.myGroup {
                    let str1 = "[members]: " + g.membersCount.toString()
                    let str2 = "\n[photos]: " + group.photosCounter.toString()
                    let str3 = "\n[albums]: " + group.albumsCounter.toString()
                    let str4 = "\n[topics]: " + group.topicsCounter.toString()
                    let str5 = "\n[videos]: " + group.videosCounter.toString()
                    let str6 = "\n[market]: " + group.marketCounter.toString()
                    let str7 = "\n[closed]: " + g.isClosed.toString()
                    str = str1 + str2 + str3 + str4 + str5 + str6 + str7
                }
                
                //resize UILABEL:
                self.counterLabel.text = str // set
                self.counterLabel.sizeToFit()
                self.constraintCounterHeight.constant = self.counterLabel.frame.size.height
                self.counterLabel.text = "" // reset
                self.counterLabel.setTextWithTypeAnimation(typedText: str, characterDelay: 10)
                
                //resize UIVIEW:
                self.headerViewOriginalHeight = self.constraintDescHeight.constant + self.constraintCounterHeight.constant + self.constraintCoverHeight.constant + 16
                self.conHeightHeader.constant = self.headerViewOriginalHeight
                
                self.stopWaitIndicator(moduleEnum)
            }
            
            // MyGroup Wall:
            if moduleEnum == .myGroupWall {
                if self.presenter.getMyGroupWallPresenter().numberOfRowsInSection() > 0 {
                    self.stopWaitIndicator(moduleEnum)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {}
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?) {
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            
            if moduleEnum == .myGroupDetail {
                self.waiter.add(vcView: self.headerView)
            }
            if moduleEnum == .myGroupWall {
                self.waiter.add(vcView: self.collectionView)
            }
        }
    }
    
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?) {
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            
            if moduleEnum == .myGroupDetail {
                self.waiter.stop(vcView: self.headerView)
            }
            
            if moduleEnum == .myGroupWall {
                self.waiter.stop(vcView: self.collectionView)
            }
        }
    }
}

//MARK: - Expanded Cell

extension MyGroupDetailViewController: WallCellProtocolDelegate {
    
    func didPressExpand(isExpand: Bool, indexPath: IndexPath) {
        presenter.getMyGroupWallPresenter().didPressExpandCell(isExpand: isExpand, indexPath: indexPath)
        UIView.animate(withDuration: 0.05, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
        
    }
}


//MARK: - UICollectionViewDelegateFlowLayout Cell
extension MyGroupDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let wallPresenter = presenter.getMyGroupWallPresenter()
        let isExpanded = wallPresenter.isExpandedCell(indexPath: indexPath)
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
