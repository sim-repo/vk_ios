import UIKit

class MyGroupDetail_ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var image_orig_top_con: NSLayoutConstraint!
    @IBOutlet weak var image_orig_lead_con: NSLayoutConstraint!
    @IBOutlet weak var image_orig_trail_con: NSLayoutConstraint!
    
    @IBOutlet weak var textView_orig_trail_con: NSLayoutConstraint!
    @IBOutlet weak var textView_orig_top_con: NSLayoutConstraint!
    @IBOutlet weak var textView_orig_lead_con: NSLayoutConstraint!
    @IBOutlet weak var textView_orig_height_con: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var label_orig_bottom_con: NSLayoutConstraint!
    @IBOutlet weak var label_orig_lead_con: NSLayoutConstraint!
    @IBOutlet weak var label_orig_trail_con: NSLayoutConstraint!
    
    @IBOutlet weak var image_mini_width1_con: NSLayoutConstraint!
    @IBOutlet weak var image_mini_top_con: NSLayoutConstraint!
    @IBOutlet weak var image_mini_bottom_con: NSLayoutConstraint!
    @IBOutlet weak var image_mini_lead_con: NSLayoutConstraint!
 
    
    @IBOutlet weak var label_mini_aspect_con: NSLayoutConstraint!
    @IBOutlet weak var label_mini_lead_con: NSLayoutConstraint!
    @IBOutlet weak var label_mini_trail_con: NSLayoutConstraint!
    @IBOutlet weak var label_mini_top_con: NSLayoutConstraint!
    @IBOutlet weak var textView_mini_trail_con: NSLayoutConstraint!
    @IBOutlet weak var textView_mini_top_con: NSLayoutConstraint!
    @IBOutlet weak var textView_mini_lead_con: NSLayoutConstraint!
    @IBOutlet weak var textView_mini_height_con: NSLayoutConstraint!
    @IBOutlet weak var primaryView: MyView_Primary!
    @IBOutlet weak var bkgView: MyView_GradiendBackground!
    @IBOutlet var mainView: MyView_SecondaryDark!
    
    var myGroup: MyGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = myGroup?.name
        descTextView?.text = myGroup?.desc
        imageView.image = UIImage(named: myGroup!.icon)
        primaryView.alpha = 0
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let navigationCtl = navigationController as! ZoomNavigatorController
        navigationCtl.popAnimator.presenting = false
        
        UIView.animate(withDuration: 2) {
            self.image_orig_top_con.isActive = false
            self.image_orig_lead_con.isActive = false
            self.image_orig_trail_con.isActive = false
            self.textView_orig_trail_con.isActive = false
            self.textView_orig_top_con.isActive = false
            self.textView_orig_lead_con.isActive = false
           // self.textView_orig_height_con.constant = 30
            self.label_orig_bottom_con.isActive = false
            self.label_orig_lead_con.isActive = false
            self.label_orig_trail_con.isActive = false

            self.image_mini_top_con.isActive = true
            self.image_mini_bottom_con.isActive = true
            self.image_mini_lead_con.isActive = true
            self.image_mini_width1_con.isActive = true


            self.label_mini_aspect_con.isActive = true
            self.label_mini_lead_con.isActive = true
            self.label_mini_top_con.isActive = true
            self.textView_mini_top_con.isActive = true
            self.textView_mini_lead_con.isActive = true
            self.textView_mini_height_con.isActive = true
            self.primaryView.alpha = 1.0
            self.bkgView.alpha = 0
            self.view.layoutIfNeeded()

        }
    }
    
    @IBAction func doBack(_ sender: Any) {
        let navigationCtl = navigationController as! ZoomNavigatorController
        navigationCtl.popAnimator.presenting = false
        navigationController?.popViewController(animated: true)
    }

}
