import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

    }
    
    
    func start(completion: (()->Void)? = nil ){

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
        DispatchQueue.main.asyncAfter(deadline: .now() + networkTimeout) { [weak self] in
            guard let self = self else { return }
            self.showSimpleAlert(completion: completion)
        }
    }
    
    func showSimpleAlert(completion: (()->Void)? = nil ) {
        let alert = UIAlertController(title: "Something Wrong",
                                      message: "network request failed try again later",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            completion?()
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
