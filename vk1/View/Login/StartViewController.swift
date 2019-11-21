import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func runLogo() {
        let w: CGFloat = 232.0
        let logoAnimation = WaitIndicator2(frame: CGRect(x: wHalfScreen - w/2.0,
                                                                y: view.frame.height/3, width: wScreen, height: 100))
        logoAnimation.backgroundColor = UIColor.clear
        view.addSubview(logoAnimation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        runLogo()
        
        DELAY_THREAD(sec: 3000) {[weak self] in
            if let (t,u) = RealmService.loadToken(),
            let token = t,
            let userId = u {
                 Session.shared.token = token
                 Session.shared.userId = userId
                self?.performSegue(withIdentifier: "ShowAppSegue", sender: nil)
            } else {
                self?.performSegue(withIdentifier: "ShowAuthSegue", sender: nil)
            }
        }
    }
}
