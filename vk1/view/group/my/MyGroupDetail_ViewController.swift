import UIKit
import Kingfisher

class MyGroupDetail_ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var closeButton: MyButton_Adaptive!
    @IBOutlet weak var image_orig_top_con: NSLayoutConstraint!
    @IBOutlet weak var image_orig_lead_con: NSLayoutConstraint!
    @IBOutlet weak var image_orig_trail_con: NSLayoutConstraint!
    @IBOutlet weak var image_orig_aspect: NSLayoutConstraint!
    @IBOutlet weak var image_mini_width1_con: NSLayoutConstraint!
    @IBOutlet weak var image_mini_top_con: NSLayoutConstraint!
    @IBOutlet weak var image_mini_bottom_con: NSLayoutConstraint!
    @IBOutlet weak var image_mini_lead_con: NSLayoutConstraint!
    @IBOutlet weak var primaryView: MyView_Primary!
    @IBOutlet weak var bkgView: MyView_GradiendBackground!
    @IBOutlet var mainView: MyView_SecondaryDark!
    
    var myGroup: MyGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        nameLabel.text = myGroup?.name
        descTextView?.text = myGroup?.desc
        imageView.kf.setImage(with: myGroup?.avaURL200)

        primaryView.alpha = 0
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // let navigationCtl = navigationController as! ZoomNavigatorController
       // navigationCtl.popAnimator.presenting = false
        nameLabel.removeFromSuperview()
        descTextView.removeFromSuperview()
        closeButton.removeFromSuperview()
        UIView.animate(withDuration: 2) {
            self.image_orig_aspect.isActive = false
            self.image_orig_top_con.isActive = false
            self.image_orig_lead_con.isActive = false
            self.image_orig_trail_con.isActive = false
            self.image_mini_top_con.isActive = true
            self.image_mini_bottom_con.isActive = true
            self.image_mini_lead_con.isActive = true
            self.image_mini_width1_con.isActive = true
            self.primaryView.alpha = 1.0
            self.bkgView.alpha = 0
            self.view.layoutIfNeeded()

        }
    }
}


// MARK: segue handlers
extension MyGroupDetail_ViewController {
    
    private func getNavigationController() -> CustomNavigationController {
        return navigationController as! CustomNavigationController
    }
    
    @IBAction func doBack(_ sender: Any) {
        guard let popAnimator = getNavigationController().popAnimator as? ZoomAnimator
        else { return } // TODO: throw err
        popAnimator.prepareForPop()
        navigationController?.popViewController(animated: true)
    }
}
