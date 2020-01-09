import UIKit


enum PostControlEnum {
    case like
    case share
    case comment
    case views
}

protocol WallFooterViewProtocolDelegate: class {
    func didPressLike()
    func didPressComment()
    func didPressShare()
}

class WallFooterView: UIImageView {
    
    private var activated = false
    var boundMetrics: UILabel?
    var color = UIColor(red: 0.919, green: 0.919, blue: 0.919, alpha: 1.000)
    var userActivityType: PostControlEnum?
    var delegate: WallFooterViewProtocolDelegate?
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap))
        return recognizer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func onTap() {
        activated = !activated
        guard let activity = userActivityType else {
            return
        }
        switch activity {
            case .like:
                doLike()
            case .comment:
                doComment()
            case .share:
                doShare()
            case .views:
                doViews()
        }
    }
    
    func rotateImage() {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 1/3*CGFloat.pi)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 2/3*CGFloat.pi)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 3/3*CGFloat.pi)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 4/3*CGFloat.pi)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                self.transform = CGAffineTransform(rotationAngle: 2*CGFloat.pi)
            })
        }, completion: {_ in
            self.transform = .identity
        })
    }
    
    private func doLike(){
        var sign: Int = 1
        let numb = Int( (boundMetrics?.text)!)
        runShakeEffect()
        if activated {
            color = UIColor(red: 0.826, green: 0.200, blue: 0.200, alpha: 1.000)
            
        } else {
            color = UIColor(red: 0.919, green: 0.919, blue: 0.919, alpha: 1.000)
            sign = numb == 0 ? 0 : -1
        }
        if let numb = numb {
            boundMetrics?.text = String(numb + sign)
        }
        boundMetrics?.textColor = color
        delegate?.didPressLike()
    }
    
    private func doComment(){
        runShakeEffect()
        delegate?.didPressComment()
    }
    
    private func doShare() {
        runShakeEffect()
        delegate?.didPressShare()
    }
    
    private func doViews() {
        runShakeEffect()
    }
    
    
    
    private func runShakeEffect(){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 3
        animation.fromValue = 0.6
        animation.toValue = 1
        animation.initialVelocity = 10
        animation.damping = 3.0
        animation.fillMode = CAMediaTimingFillMode.backwards
        animation.isRemovedOnCompletion = false
        animation.beginTime = CACurrentMediaTime()
        self.layer.add(animation, forKey: "transform.scale")
    }
}
