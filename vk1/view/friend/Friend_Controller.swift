import UIKit

class Friend_Controller: UIViewController {

    var presenter = FriendPresenter()
    
    @IBOutlet weak var lettersSearchControl: LettersSearchControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlphabetSearchControl()
    }
    
    func setupAlphabetSearchControl(){
        lettersSearchControl.delegate = self
        lettersSearchControl.updateControl(with: presenter.getGroupingProperties())
    }
}

extension Friend_Controller: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! Friend_TableCell
        
        guard let data = presenter.getData(indexPath: indexPath)
            else {
                return UITableViewCell()
        }
        
        let friend = data as! Friend
        
        cell.name?.text = friend.name
        cell.ava?.text = friend.ava
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "FriendDetailSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView")
        return view
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.sectionName(section: section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendDetailSegue" {
            if let dest = segue.destination as? Friend_CollectionController,
                let index = sender as? IndexPath {
                guard let friend = presenter.getFriend(index)
                    else {return}
                dest.presenter.setFriend(friend: friend)
            }
        }
    }
    
}


extension Friend_Controller: AlphabetSearchViewControlProtocol {
    func didEndTouch() {
        // TODO
    }
    
    func didChange(indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func getView() -> UIView {
        return self.view
    }
}
