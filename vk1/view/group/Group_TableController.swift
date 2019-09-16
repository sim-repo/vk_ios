import UIKit

class Group_TableController: UITableViewController {
    
    var groups: [Group]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groups = Group.list()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as! Group_TableCell
        cell.groupNameLabel?.text = groups[indexPath.row].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addGroupPressed(_ sender: Any) {
        performSegue(withIdentifier: "GroupSegue", sender: nil)
    }
    
}
