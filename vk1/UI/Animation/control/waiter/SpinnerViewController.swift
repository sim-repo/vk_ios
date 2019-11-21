import UIKit

class SpinnerViewController: UIViewController {
    
    var dictChildByParent: [Int:UIView] = [:]
    
    var vc: UIViewController?
    
    convenience init(vc: UIViewController) {
        self.init()
        self.vc = vc
        self.vc?.addChild(self)
        self.vc?.view.addSubview(self.view)
        didMove(toParent: vc)
    }
    
    
    func add(vcView: UIView, id: Int = 0) {
        let childView = UIView()
        childView.frame = vcView.frame
        childView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        self.view.addSubview(childView)
        self.dictChildByParent[id] = childView
        self.start(childView: childView) { childView in
            childView.removeFromSuperview()
        }
    }
    
    func finish(){
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func stop(vcView: UIView, id: Int = 0) {
        
        if let childView = dictChildByParent[id] {
            childView.removeFromSuperview()
            dictChildByParent[id] = nil
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
        let ani = WaitIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        ani.translatesAutoresizingMaskIntoConstraints = false
        ani.startAnimating()
        childView.addSubview(ani)
        ani.heightAnchor.constraint(equalToConstant: 100).isActive = true
        ani.widthAnchor.constraint(equalToConstant: 100).isActive = true
        ani.centerXAnchor.constraint(equalTo: childView.centerXAnchor).isActive = true
        ani.centerYAnchor.constraint(equalTo: childView.centerYAnchor).isActive = true
        
        
//        comment out if need standard:
//        let spinner = UIActivityIndicatorView(style: .whiteLarge)
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        spinner.startAnimating()
//        childView.addSubview(spinner)
//
//        spinner.centerXAnchor.constraint(equalTo: childView.centerXAnchor).isActive = true
//        spinner.centerYAnchor.constraint(equalTo: childView.centerYAnchor).isActive = true
    
        DispatchQueue.main.asyncAfter(deadline: .now() + Network.timeout) { [weak self] in
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
