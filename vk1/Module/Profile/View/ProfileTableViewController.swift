import UIKit

class ProfileTableViewController: UITableViewController, Storyboarded {

    private var presenter: ViewablePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}



//MARK:- CoordinatableViewProtocol
extension ProfileTableViewController: CoordinatableViewProtocol {
    func setPresenter(_ presenter: ViewablePresenterProtocol) {
        self.presenter = presenter as? ViewablePresenterProtocol
    }
}
