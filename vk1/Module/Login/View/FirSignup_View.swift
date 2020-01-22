import UIKit


class FirSignup_View: UIView {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var pswTextField: UITextField!
    
    var onRegister: ((String, String)->Void)?
    var onCancel: (()->Void)?
    
    
    @IBAction func doPressSignUp(_ sender: Any) {
        guard let login = loginTextField.text,
            let psw = pswTextField.text
            else { return }
        onRegister?(login, psw)
    }
    
    @IBAction func doPressCancel(_ sender: Any) {
        onCancel?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    func setup(onRegister: ((String, String) -> Void)?,
               onCancel: (()->Void)? ) {
        self.onRegister = onRegister
        self.onCancel = onCancel
    }
}
