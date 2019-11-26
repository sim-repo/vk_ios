import UIKit


class FirSignin_View: UIView {
    
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var pswTextField: UITextField!
    
    var completion: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBAction func doPressSignIn(_ sender: Any) {
        completion?()
    }
    
    func setup(login: String, psw: String, completion: (()->Void)? = nil ) {
        loginTextField.text = login
        pswTextField.text = psw
        self.completion = completion
    }
}
