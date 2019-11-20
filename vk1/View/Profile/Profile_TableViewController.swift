import UIKit

class Profile_TableViewController: UITableViewController {
    
    var waiter: SpinnerViewController?
    
    
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


extension Profile_TableViewController: PushPlainViewProtocol {
    func viewReloadData(moduleEnum: ModuleEnum) {
        tableView.reloadData()
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?){
        waiter = SpinnerViewController(vc: self)
        waiter?.add(vcView: view)
    }
          
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?){
        waiter?.stop(vcView: view)
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {
    }
}
