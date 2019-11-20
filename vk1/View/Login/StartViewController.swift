import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let (t,u) = RealmService.loadToken(),
        let token = t,
        let userId = u {
             Session.shared.token = token
             Session.shared.userId = userId
             performSegue(withIdentifier: "ShowAppSegue", sender: nil)
        } else {
             performSegue(withIdentifier: "ShowAuthSegue", sender: nil)
        }
    }
}
