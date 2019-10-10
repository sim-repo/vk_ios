import UIKit

class Profile_TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonElementDesigner.setupNavigationBarColor(navigationController: navigationController)
        tableView?.backgroundColor = ColorThemeHelper.background
    }
    
    @IBAction func onPressButton(_ sender: Any) {
        
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        CommonElementDesigner.headerBuilder(willDisplayHeaderView: view)
    }

}
