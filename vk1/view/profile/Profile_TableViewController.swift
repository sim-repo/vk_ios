import UIKit

class Profile_TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonElementDesigner.setupNavigationBarColor(navigationController: navigationController)
        tableView?.backgroundColor = ColorThemeHelper.background
    }
    
    @IBAction func onPressButton(_ sender: Any) {
        
    }
    
    @IBAction func pressVideo(_ sender: Any) {
        performSegue(withIdentifier: "VideoSegue", sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        CommonElementDesigner.headerBuilder(willDisplayHeaderView: view)
    }

}
