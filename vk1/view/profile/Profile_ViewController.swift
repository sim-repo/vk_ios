import UIKit

class Profile_ViewController: UIViewController {

    @IBOutlet weak var avaView: RoundedImage!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter = ProfilePresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avaView.image = UIImage(named: "actor2");
    }
    
}


extension Profile_ViewController: UITableViewDelegate, UITableViewDataSource {


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! Profile_TableCell
        cell.photoView.image = UIImage(named: presenter.getImage(indexPath))
        return cell
    }
}
