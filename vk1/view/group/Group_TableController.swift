import UIKit

class Group_TableController: UITableViewController {
    
    
    var presenter = GroupPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as! Group_TableCell
        cell.groupLabel?.text = presenter.getDesc(indexPath)
        cell.iconLabel?.text = presenter.getIcon(indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addGroupPressed(_ sender: Any) {
        performSegue(withIdentifier: "GroupSegue", sender: nil)
    }
}

extension Group_TableController {
    func getGroup(indexPath: IndexPath?) -> Group? {
        return presenter.getGroup(indexPath)
    }
}
