import UIKit

class Profile_TableViewController: UITableViewController {

    @IBOutlet weak var avaView: RoundedImage!
    @IBOutlet weak var ava2: RoundedImage!
    @IBOutlet weak var ava3: RoundedImage!
    @IBOutlet weak var ava4: RoundedImage!
    @IBOutlet weak var ava5: RoundedImage!
    @IBOutlet weak var ava6: RoundedImage!
    @IBOutlet weak var ava7: RoundedImage!
    @IBOutlet weak var ava8: RoundedImage!
    @IBOutlet weak var ava9: RoundedImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avaView.image = UIImage(named: "am-32");
        ava2.image = UIImage(named: "face1");
        ava3.image = UIImage(named: "face2");
        ava4.image = UIImage(named: "face3");
        ava5.image = UIImage(named: "face4");
        ava6.image = UIImage(named: "face5");
        ava7.image = UIImage(named: "face6");
        ava8.image = UIImage(named: "face7");
        ava9.image = UIImage(named: "face8");
        
        avaView.contentMode = .scaleAspectFit
        CommonElementDesigner.setupNavigationBarColor(navigationController: navigationController)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = #colorLiteral(red: 0.7429023385, green: 0.4646773934, blue: 0, alpha: 1)
        header.textLabel?.font = UIFont(name: "Courier New", size: 18)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = NSTextAlignment.left
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.1040619984, green: 0.1043846682, blue: 0.1082772836, alpha: 1)
        if (section == 1) {
       // header.frame.size.height = 50
        }
    }

}
