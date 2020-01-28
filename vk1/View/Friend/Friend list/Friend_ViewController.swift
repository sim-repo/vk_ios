import UIKit

class Friend_ViewController: UIViewController {

    var presenter: PullSectionPresenterProtocol?
    
    @IBOutlet weak var lettersSearchControl: LettersSearchControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var loupeImageView: UIImageView!
    @IBOutlet weak var loupeLeadingXConstraint: NSLayoutConstraint!
    @IBOutlet weak var loupeCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTextCenterDxConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonSearchCancel: UIButton!
    var searchTextWidth: CGFloat = 0
    
    var lastContentOffset: CGFloat = 0

    var waiter: SpinnerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCeil()
        setupPresenter()
        setupAlphabetSearchControl()
        setupSearchTextField()
        UIControlThemeMgt.setupNavigationBarColor(navigationController: navigationController)
    }
    
    override func didReceiveMemoryWarning() {
        (presenter as? ImageablePresenterProtocol)?.didReceiveMemoryWarning()
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getSectioned(viewDidLoad: self)
    }
    
    private func setupAlphabetSearchControl(){
        lettersSearchControl.delegate = self
        lettersSearchControl.updateControl(with: presenter?.getGroupBy())
    }
    
    private func setupSearchTextField(){
        searchTextField.layer.cornerRadius = 0
        searchTextField.layer.borderWidth = 1.0
        searchTextField.delegate = self
        searchTextWidth = searchTextWidthConstraint.constant
    }
    
    // lesson 6
    private func setupCeil(){
        let all = self.view.subviews
        for item in all {
            item.frame.origin.x = ceil(item.frame.origin.x)
            item.frame.origin.y = ceil(item.frame.origin.y)
            item.frame.size.width = ceil(item.frame.width)
            item.frame.size.height = ceil(item.frame.height)
        }
    }
    
    @IBAction func viewDidFilterInput(_ sender: Any) {
        if searchTextField.text?.isEmpty ?? true {
            searchTextReset()
            return
        }
        presenter?.viewDidFilterInput(searchTextField.text!)
    }
    
    
    @IBAction func didPressButtonSearchCancel(_ sender: Any) {
        searchTextReset()
    }
    
}

extension Friend_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! Friend_TableCell
        
        guard let friend = presenter?.getData(indexPath: indexPath) as? Friend
           else {
               return UITableViewCell()
           }
        
        //lesson 5: Cache
        if let avaURL = friend.avaURL200 {
            (presenter as? ImageablePresenterProtocol)?.tryImageLoad(indexPath: indexPath, url: avaURL)
        }
        
        cell.setup(friend: friend)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "FriendDetailSegue", sender: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hview = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
       
        
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 20))
        label.text = presenter?.getSectionTitle(section: section)
        hview.addSubview(label)
        UIControlThemeMgt.setupTableHeader(view: hview, title: label)
        return hview
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.getSectionTitle(section: section)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "FriendDetailSegue" {
            guard let indexPath = sender as? IndexPath
            else {
                Logger.catchError(msg: "Friend_Controller: prepare(for segue:)")
                return
            }
            presenter?.viewDidSeguePrepare(segueId: ModuleEnum.SegueIdEnum.detailFriend, indexPath: indexPath)
        }
    }
    
    func searchTextReset(){
        searchTextField.text = ""
        buttonSearchCancel.isEnabled = false
        buttonSearchCancel.setTitleColor(.clear, for: .normal)
        searchTextField.resignFirstResponder()
        UIView.animate(withDuration: 1.0, animations: {
            self.loupeLeadingXConstraint.isActive = false
            self.loupeCenterXConstraint.isActive = true
            self.searchTextWidthConstraint.constant = self.searchTextWidth
            self.searchTextCenterDxConstraint.isActive = false
            self.searchTextCenterXConstraint.isActive = true
            
            self.view.layoutIfNeeded()
        })
        presenter?.viewDidFilterInput("")
    }
    
}


extension Friend_ViewController: PushSectionedViewProtocol{
    
    func runPerformSegue(segueId: String, _ model: ModelProtocol?){}
    
    func runPerformSegue(segueId: String, _ indexPath: IndexPath) {}
    
    func viewReloadData(groupByIds: [String]) {
        self.lettersSearchControl.updateControl(with: groupByIds)
        self.tableView.reloadData()
    }
    
    func viewReloadImage(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?){
       waiter = SpinnerViewController(vc: self)
       waiter?.add(vcView: view)
    }
       
   func stopWaitIndicator(_ moduleEnum: ModuleEnum?){
       waiter?.stop(vcView: view)
   }
}



extension Friend_ViewController: AlphabetSearchViewControlProtocol {
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


extension Friend_ViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTextField?.text?.count != 0 {
            
        }
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty ?? true else {return}
        buttonSearchCancel.isEnabled = true
        buttonSearchCancel.setTitleColor(.white, for: .normal)
        UIView.animate(withDuration: 1.0, animations: {
            self.loupeCenterXConstraint.isActive = false
            self.loupeLeadingXConstraint.isActive = true
            self.searchTextWidthConstraint.constant = self.searchTextWidth - 80
            self.searchTextCenterXConstraint.isActive = false
            self.searchTextCenterDxConstraint.isActive = true
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty ?? true{
            searchTextReset()
        }
        return true
    }
}


extension Friend_ViewController: UIScrollViewDelegate {
    

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if lastContentOffset - 100 > scrollView.contentOffset.y {
                UIView.animate(withDuration: 0.4, animations: {
                    self.searchContainerTopConstraint.isActive = false
                    self.searchContainerBottomConstraint.isActive = true
                    self.searchTextFieldHeightConstraint.isActive = false
                    self.searchContainerHeightConstraint.isActive = false
                    self.searchView.alpha = 0
                    self.view.layoutIfNeeded()
                })
            
               } else if lastContentOffset + 100 < scrollView.contentOffset.y {
                   UIView.animate(withDuration: 0.4, animations: {
                        self.searchContainerTopConstraint.isActive = true
                        self.searchContainerBottomConstraint.isActive = false
                        self.searchContainerHeightConstraint.isActive = true
                        self.searchTextFieldHeightConstraint.isActive = true
                        self.searchView.alpha = 1
                        self.view.layoutIfNeeded()
                   })
               }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}




