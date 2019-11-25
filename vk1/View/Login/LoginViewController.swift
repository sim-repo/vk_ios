import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var waitView: UIView!
    
    var presenter: PullPlainPresenterProtocol!
    
    
    
    var waiter: SpinnerViewController?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPresenter()
        
        if let (login, psw) = RealmService.loadFirebaseCredentials() {
            loginInput.text = login
            passwordInput.text = psw
        }
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupPresenter(){
        presenter = PresenterFactory.shared.getPlain(viewDidLoad: self)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification){
        let info = notification.userInfo! as NSDictionary
        let size = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func doPressLogin(_ sender: Any) {
        signIn()
    }
    
    @IBAction func doPressRegister(_ sender: Any) {
        performSegue(withIdentifier: "ShowRegisterSegue", sender: nil)
    }
    
    @objc func keyboardWasHidden(){
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
}


extension LoginViewController: PushPlainViewProtocol{
    func viewReloadData(moduleEnum: ModuleEnum) {
    }
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?){
        waiter = SpinnerViewController(vc: self)
        waiter?.add(vcView: view)
    }
    
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?){
        waiter?.stop(vcView: view)
    }
    
    func insertItems(startIdx: Int, endIdx: Int) {}
}


// firebase:
extension LoginViewController {

    func signIn() {
        let login = loginInput.text!
        let password = passwordInput.text!
        
        Auth.auth().signIn(withEmail: login, password: password) {[weak self] (success, err) in
            if let success_ = success {
                self?.performSegue(withIdentifier: "ShowMainSegue1", sender: nil)
            } else {
                self?.showAlert(err: err?.localizedDescription ?? "")
            }
        }
    }
    
    func showAlert(err: String) {
          let alert = UIAlertController(title: "Wrong registration",
                                               message: err,
                                               preferredStyle: UIAlertController.Style.alert)
                 
          alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
          self.present(alert, animated: true, completion: nil)
      }
}
