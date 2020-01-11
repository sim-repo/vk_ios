import UIKit

class NewsComment_ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var presenter: PullPlainPresenterProtocol!
    var cellHeights = [IndexPath: CGFloat]()
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupPresenter()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.allowsSelection = false
    }
    
    private func registerCell(){
        let nib1 = UINib(nibName: NewsCommentTop_TableViewCell.clazz(), bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: NewsCommentTop_TableViewCell.id())
        
        let nib2 = UINib(nibName: NewsCommentUser_TableViewCell.clazz(), bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: NewsCommentUser_TableViewCell.id())
    }
    
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
        guard  let _ = presenter as? PullWallPresenterProtocol
            else {
                log("setupPresenter(): conformation exception", level: .error)
                return
        }
    }
    
    private func getPullCommentPresenterProtocol() -> PullCommentPresenterProtocol? {
        guard let _ = presenter as? PullCommentPresenterProtocol
            else {
                log("getPullCommentPresenterProtocol(): presenter must be conformed PullCommentPresenterProtocol", level: .error)
                return nil
        }
        return presenter as? PullCommentPresenterProtocol
    }
    
    
    func didPressShowLikes() {
        getPullCommentPresenterProtocol()?.didPressShowLikes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueEnum: ModuleEnum.SegueIdEnum = .postLikes
        guard let indexPath = sender as? IndexPath
            else {
                Logger.catchError(msg: "NewsPost_ViewController: prepare(for segue:)")
                return }
        segue.destination.modalPresentationStyle = .custom
        presenter.viewDidSeguePrepare(segueId: segueEnum, indexPath: indexPath)
    }
    
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        SEQUENCE_THREAD {
            switch level {
            case .info:
                Logger.console(msg: "NewsComment_ViewController: " + msg, printEnum: .pagination)
            case .warning:
                Logger.catchWarning(msg: "NewsComment_ViewController: " + msg)
            case .error:
                Logger.catchError(msg: "NewsComment_ViewController: " + msg)
            }
        }
    }
}


extension NewsComment_ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return topCell()
        default:
            return userCell(indexPath)
        }
    }
    
    private func topCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCommentTop_TableViewCell.id(), for: IndexPath(row: 0, section: 0)) as! NewsCommentTop_TableViewCell
        guard let news = getPullCommentPresenterProtocol()?.getNews()
            else {
                log("cellForItemAt(): news is nil", level: .error)
                return cell
        }
        cell.delegate = self
        cell.setup(news, isExpanded)
        return cell
    }
    
    private func userCell(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let comment = presenter.getData(indexPath: indexPath) as? Comment
            else {
                log("cellForItemAt(): presenter.getData is incorrect ", level: .error)
                return UITableViewCell()
        }
        
        let cellIdentifier = CommentCellConstant.getCellIdentifier2(imageCount: comment.imageURLs.count)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsCommentUser_TableViewCell
        cell.setup(comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellHeights[indexPath] == nil {
            cellHeights[indexPath] = cell.bounds.height
            print("height : \(cell.bounds.height)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if cellHeights[indexPath] == nil {
            var cellId = ""
            switch indexPath.row {
            case 0:
                cellId = NewsCommentTop_TableViewCell.clazz()
                let objects = UINib(nibName: cellId, bundle: nil).instantiate(withOwner: nil, options: nil)
                let cell = objects.first as! UITableViewCell
                if let news = getPullCommentPresenterProtocol()?.getNews() {
                    let topCell = cell as? NewsCommentTop_TableViewCell
                    topCell?.setup(news, isExpanded)
                    let v = cell.contentView
                    let sz = v.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    cellHeights[indexPath] = sz.height
                }
                
            default:
                cellId = NewsCommentUser_TableViewCell.clazz()
                let objects = UINib(nibName: cellId, bundle: nil).instantiate(withOwner: nil, options: nil)
                let cell = objects.first as! UITableViewCell
                for row in 1..<presenter.numberOfRowsInSection() {
                    let idx = IndexPath(row: row, section: 0)
                    if let comment = presenter.getData(indexPath: idx) as? Comment {
                        let commentCell = cell as! NewsCommentUser_TableViewCell
                        commentCell.setup(comment)
                        let v = commentCell.contentView
                        let sz = v.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                        cellHeights[idx] = sz.height + commentCell.audioSizeBlock
                    }
                }
            }
        }
        return cellHeights[indexPath]!
    }
}



//MARK: - PushWallViewProtocol
extension NewsComment_ViewController: PushViewProtocol {
   
    
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?) {
    }
    
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?) {
    }
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol?) {
       
    }
    
    func runPerformSegue(segueId: String, _ indexPath: IndexPath) {
        performSegue(withIdentifier: segueId, sender: indexPath)
    }
}


//MARK: - PushPlainViewProtocol
extension NewsComment_ViewController: PushPlainViewProtocol {
    
    func viewReloadData(moduleEnum: ModuleEnum) {
        PRESENTER_UI_THREAD { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {
    }
}


//MARK: - CommentCellProtocolDelegate

extension NewsComment_ViewController: CommentCellProtocolDelegate {
    
    func didPressExpand() {
        isExpanded = true
        cellHeights[IndexPath(row: 0, section: 0)] = nil
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}



