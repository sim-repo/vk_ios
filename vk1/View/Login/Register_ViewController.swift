import UIKit
import FirebaseAuth


class Register_ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var pswTextField: UITextField!
    
    @IBAction func doPressSignUp(_ sender: Any) {
        guard let login = loginTextField.text,
            let psw = pswTextField.text
            else { return }
        register(email: login, psw: psw)
    }
    
    func register(email: String, psw: String) {
        Auth.auth().createUser(withEmail: email, password: psw) { [weak self] (success, err) in
            if let _ = success {
                RealmService.saveFirebaseCredentials(login: email, psw: psw)
                self?.performSegue(withIdentifier: "ShowMainSegue3", sender: nil)
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
