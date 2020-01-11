import UIKit

class Likes_ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var presenter: PullPlainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
        guard  let _ = presenter as? PullWallPresenterProtocol
            else {
                log("setupPresenter(): conformation exception", level: .error)
                return
        }
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        SEQUENCE_THREAD {
            switch level {
            case .info:
                Logger.console(msg: "Likes_ViewController: " + msg, printEnum: .pagination)
            case .warning:
                Logger.catchWarning(msg: "Likes_ViewController: " + msg)
            case .error:
                Logger.catchError(msg: "Likes_ViewController: " + msg)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension Likes_ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(presenter.numberOfRowsInSection())")
        return presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Likes_TableViewCell.id(), for: IndexPath(row: 0, section: 0)) as! Likes_TableViewCell
        guard let like = presenter.getData(indexPath: indexPath) as? Like
               else {
                   log("cellForItemAt(): presenter.getData is incorrect ", level: .error)
                   return UITableViewCell()
               }
        cell.setup(like: like)
        return cell
    }
}



//MARK: - Likes_ViewController
extension Likes_ViewController: PushViewProtocol {

    func startWaitIndicator(_ moduleEnum: ModuleEnum?) {}

    func stopWaitIndicator(_ moduleEnum: ModuleEnum?) {}

    func runPerformSegue(segueId: String, _ model: ModelProtocol?) {}

    func runPerformSegue(segueId: String, _ indexPath: IndexPath) {}
}


//MARK: - PushPlainViewProtocol
extension Likes_ViewController: PushPlainViewProtocol {
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        PRESENTER_UI_THREAD { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {
    }
}
