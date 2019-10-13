import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    
    let interactiveTransition = CustomInteractiveTransition()
    var pushAnimator: UIViewControllerAnimatedTransitioning?
    var popAnimator: UIViewControllerAnimatedTransitioning?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)-> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
            case .push:
                return pushAnimator
            case .pop:
                return popAnimator
            case .none:
                return nil
            @unknown default:
                fatalError()
        }
    }
    
    func setup(pushAnimator: UIViewControllerAnimatedTransitioning, popAnimator: UIViewControllerAnimatedTransitioning){
        self.pushAnimator = pushAnimator
        self.popAnimator = popAnimator
    }
}
