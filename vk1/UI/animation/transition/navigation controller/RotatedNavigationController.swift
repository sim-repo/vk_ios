import UIKit

class RotatedNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    
    let interactiveTransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        let recognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                                 action: #selector(handleScreenEdgeGesture(_:)))
        recognizer.edges = [.left]
        view.addGestureRecognizer(recognizer)
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)-> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
            case .push:
                return RotatedPushAnimator()
            case .pop:
                return RotatedPopAnimator()
            case .none:
                return nil
            @unknown default:
                fatalError()
        }
    }
    
   @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {

       switch recognizer.state {

       case .began:
           interactiveTransition.hasStarted = true
           self.popViewController(animated: true)
       case .changed:
           guard let width = recognizer.view?.bounds.width else {
               interactiveTransition.hasStarted = false
               interactiveTransition.cancel()
               return
           }
           
           let translation = recognizer.translation(in: recognizer.view)
           let relativeTranslation = translation.x / width
           let progress = max(0, min(1, relativeTranslation))

           interactiveTransition.shouldFinish = progress > 0.2
           interactiveTransition.update(progress)

       case .ended:
           interactiveTransition.hasStarted = false
           interactiveTransition.shouldFinish ?
               interactiveTransition.finish() :
               interactiveTransition.cancel()

       case .cancelled:
           interactiveTransition.hasStarted = false
           interactiveTransition.cancel()
           
       default: return
       }
   }

    
}
