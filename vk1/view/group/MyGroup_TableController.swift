import UIKit


class MyGroup_TableController: UITableViewController {

    
    var presenter = MyGroupPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupTableCell", for: indexPath) as! MyGroup_TableCell
        cell.groupLabel?.text = presenter.getDesc(indexPath)
        cell.iconLabel.text = presenter.getIcon(indexPath)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addGroupPressed(_ sender: Any) {
        performSegue(withIdentifier: "GroupSegue", sender: nil)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroupSegue",
        let controller = segue.source as? Group_TableController {
            if let indexPath = controller.tableView.indexPathForSelectedRow,
               let selected = controller.getGroup(indexPath: indexPath) {
                if presenter.addGroup(group: selected) {
                    let indexPath = presenter.getIndexPath()
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeGroup(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
