import UIKit

class WaitIndicator {
    
    var timer: Timer!
    var point1: UIView!
    var point2: UIView!
    var point3: UIView!
    var pointContainer: UIView!
    var isLoadComplete = false
    var finishCount: Int = 0
    var parentView: UIView
    let activeColor = UIColor(displayP3Red: 1/255, green: 120/255, blue: 254/255, alpha: 1.0)
    
    init(_parentView: UIView) {
        self.parentView = _parentView
        initIndicator()
    }
    
    func initIndicator(){
        let wPoint = parentView.frame.width / 6
        pointContainer = UIView(frame: CGRect(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.height))
        point1 = UIView(frame: CGRect(x: 0, y: 0, width: wPoint, height: wPoint))
        point1.backgroundColor = activeColor
        point2 = UIView(frame: CGRect(x: wPoint*2, y: 0, width: wPoint, height: wPoint))
        point2.backgroundColor = UIColor.gray
        point3 = UIView(frame: CGRect(x: wPoint*4, y: 0, width: wPoint, height: wPoint))
        point3.backgroundColor = UIColor.gray
        
        pointContainer.addSubview(point1)
        pointContainer.addSubview(point2)
        pointContainer.addSubview(point3)
        parentView.addSubview(pointContainer)
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerTimeUp), userInfo: nil, repeats: true)
    }
    
    
    @objc func timerTimeUp() {
        finishCount += 1
        isLoadComplete = finishCount >= 5
        self.loadIndicator()
    }
    
    
    func loadIndicator(){
        
        UIView.animateKeyframes(
            withDuration: 0.5,
            delay: 0.0,
            options: [],
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
                
        },
            completion: {_ in
                if self.isLoadComplete {
                    self.parentView.removeFromSuperview()
                    self.timer.invalidate()
                    self.pointContainer.removeFromSuperview()
                }
        })
    }
}
