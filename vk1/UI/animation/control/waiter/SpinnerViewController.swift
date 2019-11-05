import UIKit

class SpinnerViewController: UIViewController {
    
    var dictChildByParent: [UIView:UIView] = [:]
    var vc: UIViewController?
    
    convenience init(vc: UIViewController) {
        self.init()
        self.vc = vc
        self.vc?.addChild(self)
       // view.frame = vc.view.frame
        self.vc?.view.addSubview(self.view)
        didMove(toParent: vc)
    }
    
    
    func add(vcView: UIView) {
        let childView = UIView()
        childView.frame = vcView.frame
        childView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        self.view.addSubview(childView)
        dictChildByParent[vcView] = childView
        start(childView: childView) { childView in
            childView.removeFromSuperview()
        }
    }
    
    
    func finish(){
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func stop(vcView: UIView) {
        if let childView = dictChildByParent[vcView] {
            childView.removeFromSuperview()
            dictChildByParent[vcView] = nil
        }
        if dictChildByParent.isEmpty {
            finish()
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.9)
    }
    
    
    func start(childView: UIView, completion: ((UIView)->Void)? = nil ){
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        childView.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: childView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: childView.centerYAnchor).isActive = true
    
        DispatchQueue.main.asyncAfter(deadline: .now() + networkTimeout) { [weak self] in
            guard let self = self else { return }
            self.showSimpleAlert()
        }
    }
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Something Wrong",
                                      message: "network request failed try again later",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {[weak self] _ in
            self?.finish()
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
