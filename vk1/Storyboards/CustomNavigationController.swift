import UIKit

class CustomNavigationController: UINavigationController, Storyboarded2 {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func changeBack(title: String) {
        let backBarButtton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
    }
}
