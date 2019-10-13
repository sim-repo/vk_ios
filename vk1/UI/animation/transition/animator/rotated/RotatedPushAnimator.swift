import UIKit

class RotatedPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let source = transitionContext.viewController(forKey: .from)
            else { return }
        guard let destination = transitionContext.viewController(forKey: .to)
            else { return }

        //who will be displayed
        transitionContext.containerView.addSubview(destination.view)
        

        //copy coordinates
        let destinationViewTargetFrame = source.view.frame
        
        
        //where should be displayed
        destination.view.frame = CGRect(x: destinationViewTargetFrame.width,
                                        y: destinationViewTargetFrame.height/2,
                                        width: destinationViewTargetFrame.width,
                                        height: destinationViewTargetFrame.height)
        
        //how should be transoformed
        destination.view.transform = CGAffineTransform(rotationAngle: .pi/2)
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 1)

        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: [.calculationModeLinear],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1){
                                       destination.view.transform = CGAffineTransform(rotationAngle:  -.pi*2)
                                       
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2/2){
                                        destination.view.frame = destinationViewTargetFrame
                                    }
        }){ finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }

}

