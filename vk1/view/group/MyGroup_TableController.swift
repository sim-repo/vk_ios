import UIKit


class MyGroup_TableController: UITableViewController {

    
    var myGroups: [MyGroup]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myGroups = MyGroup.list()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupTableCell", for: indexPath) as! MyGroup_TableCell
        cell.myGroupNameLabel?.text = myGroups[indexPath.row].text
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addGroupPressed(_ sender: Any) {
        performSegue(withIdentifier: "GroupSegue", sender: nil)
    }
    
}
