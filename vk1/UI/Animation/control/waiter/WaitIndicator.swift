import UIKit

class WaitIndicator: UIView{
    
    var timer: Timer!
    var point1: UIView!
    var point2: UIView!
    var point3: UIView!
    var pointContainer: UIView!
    let activeColor = ColorSystemHelper.onBackground
    var isTimeUp = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startAnimating(){
        let wPoint = min(self.frame.width / 6, 30)
        pointContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        point1 = UIView(frame: CGRect(x: 0, y: 0, width: wPoint, height: wPoint))
        point1.backgroundColor = activeColor
        point2 = UIView(frame: CGRect(x: wPoint*2, y: 0, width: wPoint, height: wPoint))
        point2.backgroundColor = UIColor.gray
        point3 = UIView(frame: CGRect(x: wPoint*4, y: 0, width: wPoint, height: wPoint))
        point3.backgroundColor = UIColor.gray
        
        pointContainer.addSubview(point1)
        pointContainer.addSubview(point2)
        pointContainer.addSubview(point3)
        addSubview(pointContainer)
        animate()
    }
    
    
    func animate(){
        
        UIView.animateKeyframes(
            withDuration: 1.5,
            delay: 0.0,
            options: [.repeat],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4, animations: {
                    self.point1.transform = CGAffineTransform(scaleX: 2, y: 2)
                    self.point1.backgroundColor = self.activeColor
                })
                
                
                UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration:1/4, animations: {
                    self.point1.transform = .identity
                    self.point1.backgroundColor = UIColor.gray
                    self.point2.transform = CGAffineTransform(scaleX: 2, y: 2)
                    self.point2.backgroundColor = self.activeColor
                })
                
                UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4, animations: {
                    self.point2.transform = .identity
                    self.point2.backgroundColor = UIColor.gray
                    self.point3.transform = CGAffineTransform(scaleX: 2, y: 2)
                    self.point3.backgroundColor = self.activeColor
                })
                
                UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4, animations: {
                    self.point3.transform = .identity
                    self.point3.backgroundColor = UIColor.gray
                })
        }
        )
    }
}
