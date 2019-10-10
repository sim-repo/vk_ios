import UIKit

class ZoomNavigatorController: UINavigationController, UINavigationControllerDelegate {
    
    
    let interactiveTransition = CustomInteractiveTransition()
    let popAnimator = ZoomPopAnimator()
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
                return popAnimator
            case .pop:
                return popAnimator
            case .none:
                return nil
            @unknown default:
                fatalError()
        }
    }
}
