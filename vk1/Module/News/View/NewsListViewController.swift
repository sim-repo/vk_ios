import UIKit

class NewsListViewController: UIViewController, Storyboarded {

    private var presenter: ViewablePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


//MARK:- CoordinatableViewProtocol
extension NewsListViewController: CoordinatableViewProtocol {
    func setPresenter(_ presenter: ViewablePresenterProtocol) {
        self.presenter = presenter as? ViewablePresenterProtocol
    }
}
