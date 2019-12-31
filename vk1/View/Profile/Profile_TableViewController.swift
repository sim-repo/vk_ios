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
    
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol?){}
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?){
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.waiter = SpinnerViewController(vc: self)
            self.waiter?.add(vcView: self.view)
        }
    }
          
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?){
        PRESENTER_UI_THREAD { [weak self] in
            guard let self = self else { return }
            self.waiter?.stop(vcView: self.view)
        }
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {
    }
}
