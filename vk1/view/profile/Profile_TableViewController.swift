import UIKit

class Profile_TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIControlThemeMgt.setupNavigationBarColor(navigationController: navigationController)
        tableView?.backgroundColor = ColorSystemHelper.background
    }
    
    @IBAction func onPressButton(_ sender: Any) {
        
    }
    
    @IBAction func pressVideo(_ sender: Any) {
        performSegue(withIdentifier: "VideoSegue", sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        UIControlThemeMgt.setupTableHeader(willDisplayHeaderView: view)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "VideoSegue", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}
