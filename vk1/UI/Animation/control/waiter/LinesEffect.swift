import UIKit

class LinesEffect: UIView {

    override init(frame: CGRect) {
       super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func getBezierPath() -> UIBezierPath {
       let bezierPath = UIBezierPath()
       bezierPath.move(to: CGPoint(x: 0, y: 0))
       bezierPath.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
       bezierPath.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
       bezierPath.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
       bezierPath.addLine(to: CGPoint(x: 0, y: 0))
       bezierPath.close()
       return bezierPath
    }



    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let bezierPath = getBezierPath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = ColorSystemHelper.secondary.cgColor
        shapeLayer.fillColor = ColorSystemHelper.clearColor.cgColor
        shapeLayer.lineWidth = 1
        self.layer.addSublayer(shapeLayer)

        let anim1 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd) )
        anim1.fromValue = 0
        anim1.toValue = 1
        anim1.duration = 4.0
        anim1.fillMode = CAMediaTimingFillMode.forwards
        anim1.isRemovedOnCompletion = true
        shapeLayer.add(anim1, forKey: #keyPath(CAShapeLayer.strokeEnd) )
    }
}
