import UIKit
import Kingfisher

class MyGroupDetail_ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // counters:
    @IBOutlet weak var membersCountLabel: MyLabel_Adaptive!
    @IBOutlet weak var photosCountLabel: MyLabel_Adaptive!
    @IBOutlet weak var albumsCountLabel: MyLabel_Adaptive!
    @IBOutlet weak var topicsCountLabel: MyLabel_Adaptive!
    @IBOutlet weak var videosCountLabel: MyLabel_Adaptive!
    @IBOutlet weak var marketCountLabel: MyLabel_Adaptive!
    @IBOutlet weak var isClosedCountLabel: MyLabel_Adaptive!
    @IBOutlet weak var isDeactivatedLabel: MyLabel_Adaptive!
    
    @IBOutlet weak var bkgView: MyView_GradiendBackground!
    @IBOutlet var mainView: MyView_SecondaryDark!
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var countersStackView: UIStackView!
    
    var presenter: PullPlainPresenterProtocol!
    
    var waiter: SpinnerViewController?
    
    
    override func viewWillAppear(_ animated: Bool) {
        parentView.alpha = 0
        createSpinnerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            guard let popAnimator = getNavigationController().popAnimator as? ZoomAnimator
                   else { return }
            nameLabel.removeFromSuperview()
            descTextView.removeFromSuperview()
            countersStackView.removeFromSuperview()
            popAnimator.prepareForPop()
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.popViewController(animated: false)
        presenter.viewDidDisappear()
    }
    
    func createSpinnerView() {
        waiter = SpinnerViewController()
        waiter?.start() { [weak self] in
            self?.waiter?.willMove(toParent: nil)
            self?.waiter?.view.removeFromSuperview()
            self?.waiter?.removeFromParent()
        }
        if let w = waiter {
            addChild(w)
            w.view.frame = view.frame
            view.addSubview(w.view)
            w.didMove(toParent: self)
        }
    }
}


// MARK: segue handlers
extension MyGroupDetail_ViewController {
    private func getNavigationController() -> CustomNavigationController {
        return navigationController as! CustomNavigationController
    }
}


extension MyGroupDetail_ViewController: PushPlainViewProtocol{
    
    func viewReloadData() {
        console(msg: "MyGroupDetail_ViewController: refreshDataSource()")
        
        waiter?.willMove(toParent: nil)
        waiter?.view.removeFromSuperview()
        waiter?.removeFromParent()
        
        
        guard let group = presenter.getData(indexPath: nil) as? DetailGroup
                      else { catchError(msg: "MyGroupDetail_ViewController: setup(): datasource is null" )
                             return
                      }
                  
        nameLabel.text = group.name
        descTextView?.text = group.desc
        if group.coverURL400 == nil {
            coverImageView.kf.setImage(with: group.avaURL200)
        } else {
           imageView.kf.setImage(with: group.avaURL200)
           coverImageView.kf.setImage(with: group.coverURL400)
        }
        
        membersCountLabel.text =  "[members]: " + group.membersCount.toString()
        photosCountLabel.text = "[photos]: " + group.photosCounter.toString()
        albumsCountLabel.text = "[albums]: " + group.albumsCounter.toString()
        topicsCountLabel.text = "[topics]: " + group.topicsCounter.toString()
        videosCountLabel.text = "[videos]: " + group.videosCounter.toString()
        marketCountLabel.text = "[market]: " + group.marketCounter.toString()
        isClosedCountLabel.text = "[closed]: " + group.isClosed.toString()
        isDeactivatedLabel.text = "[deactivated]: " + group.isDeactivated.toString()
        parentView.alpha = 1
    }
}
