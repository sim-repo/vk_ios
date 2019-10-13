import UIKit



class ZoomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
    
    let duration = 2.0
    var presenting = true
    var originFrame = CGRect.zero

    var dismissCompletion: (() -> Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let targetView = presenting ? toView : transitionContext.view(forKey: .from)!

        let initialFrame = presenting ? originFrame : targetView.frame
        let finalFrame = presenting ? targetView.frame : originFrame

        let xScaleFactor = presenting ?
          initialFrame.width / finalFrame.width :
          finalFrame.width / initialFrame.width

        let yScaleFactor = presenting ?
          initialFrame.height / finalFrame.height :
          finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        if presenting {
          targetView.transform = scaleTransform
          targetView.center = CGPoint(
            x: initialFrame.midX,
            y: initialFrame.midY)
          targetView.clipsToBounds = true
        }

        targetView.layer.cornerRadius = presenting ? 20.0 : 0.0
        targetView.layer.masksToBounds = true

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(targetView)

        UIView.animate(
          withDuration: duration,
          delay:0.0,
          usingSpringWithDamping: 1,
          initialSpringVelocity: 0.0,
          animations: {
            targetView.transform = self.presenting ? .identity : scaleTransform
            targetView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            targetView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
        }, completion: { _ in
          if !self.presenting {
            self.dismissCompletion?()
          }
          transitionContext.completeTransition(true)
        })
    }
    
    
    func prepareForPush(cell: UICollectionViewCell) {
        guard let superview = cell.superview
            else { return } //TODO: throw err
        originFrame = superview.convert(cell.frame, to: nil)
        originFrame = CGRect(
             x: originFrame.origin.x,
             y: originFrame.origin.y,
             width: originFrame.size.width ,
             height: originFrame.size.height
        )
        presenting = true
    }
    
    func prepareForPop() {
        presenting = false
    }

    private func handleRadius(recipeView: UIView, hasRadius: Bool) {
        recipeView.layer.cornerRadius = hasRadius ? 20.0 : 0.0
    }
}
