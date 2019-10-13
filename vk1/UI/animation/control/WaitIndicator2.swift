import UIKit

class WaitIndicator2: UIView, CAAnimationDelegate {
    
    let lighting = CAShapeLayer()
    
    
    override init(frame: CGRect) {
       super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func getBezierPath() -> UIBezierPath {
       let bezierPath = UIBezierPath()
       bezierPath.move(to: CGPoint(x: 41.26, y: 62.74))
       bezierPath.addLine(to: CGPoint(x: 116.58, y: 62.74))
       bezierPath.addCurve(to: CGPoint(x: 123.5, y: 62.72), controlPoint1: CGPoint(x: 116.58, y: 62.74), controlPoint2: CGPoint(x: 119.55, y: 62.99))
       bezierPath.addCurve(to: CGPoint(x: 136.01, y: 56.98), controlPoint1: CGPoint(x: 127.57, y: 62.43), controlPoint2: CGPoint(x: 132.67, y: 61.55))
       bezierPath.addCurve(to: CGPoint(x: 136.01, y: 36.44), controlPoint1: CGPoint(x: 142.61, y: 47.97), controlPoint2: CGPoint(x: 136.01, y: 36.44))
       bezierPath.addCurve(to: CGPoint(x: 119.35, y: 26.7), controlPoint1: CGPoint(x: 136.01, y: 36.44), controlPoint2: CGPoint(x: 130.81, y: 26.34))
       bezierPath.addCurve(to: CGPoint(x: 107.55, y: 31.75), controlPoint1: CGPoint(x: 107.9, y: 27.06), controlPoint2: CGPoint(x: 107.55, y: 31.75))
       bezierPath.addCurve(to: CGPoint(x: 82.22, y: 9.05), controlPoint1: CGPoint(x: 107.55, y: 31.75), controlPoint2: CGPoint(x: 103.39, y: 10.13))
       bezierPath.addCurve(to: CGPoint(x: 56.88, y: 26.7), controlPoint1: CGPoint(x: 61.05, y: 7.96), controlPoint2: CGPoint(x: 56.88, y: 26.7))
       bezierPath.addCurve(to: CGPoint(x: 41.26, y: 26.7), controlPoint1: CGPoint(x: 56.88, y: 26.7), controlPoint2: CGPoint(x: 49.59, y: 22.74))
       bezierPath.addCurve(to: CGPoint(x: 32.24, y: 36.44), controlPoint1: CGPoint(x: 32.93, y: 30.67), controlPoint2: CGPoint(x: 32.24, y: 36.44))
       bezierPath.addCurve(to: CGPoint(x: 14.68, y: 36.61), controlPoint1: CGPoint(x: 32.24, y: 36.44), controlPoint2: CGPoint(x: 22.32, y: 30.13))
       bezierPath.addCurve(to: CGPoint(x: 11.05, y: 54.77), controlPoint1: CGPoint(x: 7.05, y: 43.1), controlPoint2: CGPoint(x: 11.05, y: 54.77))
       bezierPath.addCurve(to: CGPoint(x: 20.14, y: 62.72), controlPoint1: CGPoint(x: 11.05, y: 54.77), controlPoint2: CGPoint(x: 14.24, y: 62.72))
       bezierPath.addCurve(to: CGPoint(x: 41.26, y: 62.74), controlPoint1: CGPoint(x: 26.04, y: 62.72), controlPoint2: CGPoint(x: 41.26, y: 62.74))
       bezierPath.close()
       return bezierPath
    }

    func runAnimate(){
  
        let strokeColor: UIColor = .clear
        //http://www.paintcodeapp.com
        let duration = 2.0
        let wLine: CGFloat = 4.0
        
        var path = UIBezierPath()
        UIColor.black.setStroke()
        path.lineWidth = 2
        path.stroke()
        logoAnimate (path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)
        

        path = UIBezierPath()
        path.move(to: CGPoint(x: 259.92, y: 33.73))
        path.move(to: CGPoint(x: 212.92, y: 15.73))
        path.addLine(to: CGPoint(x: 176.09, y: -0.36))
        path.addLine(to: CGPoint(x: 116.77, y: 19.69))
        path.addLine(to: CGPoint(x: 147.94, y: 38.06))
        path.addLine(to: CGPoint(x: 227.75, y: 85.12))
        path.addCurve(to: CGPoint(x: 176.57, y: 109.13), controlPoint1: CGPoint(x: 227.75, y: 85.12), controlPoint2: CGPoint(x: 176.7, y: 109.25))
        path.addCurve(to: CGPoint(x: 126.82, y: 82.22), controlPoint1: CGPoint(x: 176.43, y: 109.01), controlPoint2: CGPoint(x: 126.82, y: 82.22))
        UIColor.black.setStroke()
        path.lineWidth = 0.5 * wLine
        path.stroke()
        logoAnimate (path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)


        path = UIBezierPath()
        path.move(to: CGPoint(x: 211.66, y: 20.19))
        path.addLine(to: CGPoint(x: 178.37, y: 5.6))
        path.addLine(to: CGPoint(x: 131.76, y: 20.19))
        path.addLine(to: CGPoint(x: 178.37, y: 47.27))
        UIColor.black.setStroke()
        path.lineWidth = 1 * wLine
        path.stroke()
        logoAnimate (path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)


        path = UIBezierPath()
        path.move(to: CGPoint(x: 127.32, y: 76.44))
        path.addLine(to: CGPoint(x: 178.37, y: 103.52))
        path.addLine(to: CGPoint(x: 216.1, y: 84.77))
        path.addLine(to: CGPoint(x: 153.95, y: 47.27))
        UIColor.black.setStroke()
        path.lineWidth = 1 * wLine
        path.stroke()
        logoAnimate (path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)
        

        path = UIBezierPath()
        path.move(to: CGPoint(x: 43.23, y: 0.12))
        path.addLine(to: CGPoint(x: 0.25, y: -0.13))
        path.addLine(to: CGPoint(x: 0.25, y: 109.25))
        path.addLine(to: CGPoint(x: 13.66, y: 109.25))
        path.addLine(to: CGPoint(x: 13.66, y: 54.07))
        path.addLine(to: CGPoint(x: 43.53, y: 54.07))
        UIColor.black.setStroke()
        path.lineWidth = 0.5 * wLine
        path.stroke()
        logoAnimate (path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)


        path = UIBezierPath()
        path.move(to: CGPoint(x: 116.22, y: 5.21))
        path.addLine(to: CGPoint(x: 40.2, y: 5.08))
        path.addLine(to: CGPoint(x: 40.2, y: 19.67))
        UIColor.black.setStroke()
        path.lineWidth = 0.5 * wLine
        path.stroke()
        logoAnimate (path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)


        path = UIBezierPath()
        path.move(to: CGPoint(x: 216.65, y: 28))
        path.addLine(to: CGPoint(x: 184.47, y: 13.42))
        path.addLine(to: CGPoint(x: 151.18, y: 23.83))
        path.addLine(to: CGPoint(x: 184.47, y: 42.58))
        UIColor.black.setStroke()
        path.lineWidth = 0.5 * wLine
        path.stroke()
        logoAnimate (path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)


        
        path = UIBezierPath()
        path.move(to: CGPoint(x: 144.75, y: 51.75))
        path.addLine(to: CGPoint(x: 201.25, y: 85.25))
        path.addLine(to: CGPoint(x: 176.25, y: 96.25))
        path.addLine(to: CGPoint(x: 123.25, y: 66.75))
        UIColor.black.setStroke()
        path.lineWidth = 0.5 * wLine
        path.stroke()
        logoAnimate (path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)

        
        path = UIBezierPath()
        path.move(to: CGPoint(x: 52.96, y: 0.4))
        path.addLine(to: CGPoint(x: 115.66, y: -0.13))
        UIColor.black.setStroke()
        path.lineWidth = 0.5 * wLine
        path.stroke()
        logoAnimate(path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)

        
        path = UIBezierPath()
        path.move(to: CGPoint(x: 23, y: 107.69))
        path.addLine(to: CGPoint(x: 23, y: 61.85))
        path.addLine(to: CGPoint(x: 54.07, y: 61.85))
        path.addLine(to: CGPoint(x: 54.07, y: 36.85))
        path.addLine(to: CGPoint(x: 29.66, y: 36.85))
        UIColor.black.setStroke()
        path.lineWidth = 1 * wLine
        path.stroke()
        logoAnimate(path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)

        
        path = UIBezierPath()
        path.move(to: CGPoint(x: 54.07, y: 16.02))
        path.addCurve(to: CGPoint(x: 109.56, y: 16.02), controlPoint1: CGPoint(x: 49.63, y: 16.02), controlPoint2: CGPoint(x: 109.56, y: 16.02))
        UIColor.black.setStroke()
        path.lineWidth = 1 * wLine
        path.stroke()
        logoAnimate (path: path, color: ColorSystemHelper.secondary, duration: duration, width: path.lineWidth)
        


       let rectangle2Path = UIBezierPath(rect: CGRect(x: 294.5, y: 33.5, width: 1, height: 1))
       UIColor.black.setStroke()
       rectangle2Path.lineWidth = 1
       rectangle2Path.stroke()


        
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 5.5, y: 77.5))
        bezier4Path.addLine(to: CGPoint(x: 62.5, y: 77.5))
        bezier4Path.addLine(to: CGPoint(x: 80.5, y: 34.5))
        bezier4Path.addLine(to: CGPoint(x: 106.5, y: 108.5))
        bezier4Path.addLine(to: CGPoint(x: 131.5, y: 48.5))
        bezier4Path.addLine(to: CGPoint(x: 142.5, y: 77.5))
        bezier4Path.addLine(to: CGPoint(x: 400.5, y: 77.5))
        strokeColor.setStroke()
        bezier4Path.lineWidth = 1
        bezier4Path.stroke()
        let tail = #colorLiteral(red: 0.8445646167, green: 0, blue: 0.2279720902, alpha: 1)
        lightingAnimate(path: bezier4Path, color: tail, duration: 1.0, startTime: 1.0)
    }

    
    
    func lightingAnimate(path: UIBezierPath, color: UIColor, duration: Double, startTime: Double){
        lighting.path = path.cgPath
        lighting.strokeColor = color.cgColor
        lighting.lineWidth = 8
        lighting.fillColor = nil
        self.layer.addSublayer(lighting)
        
        
        let inAnimation1 = CABasicAnimation(keyPath:  #keyPath(CAShapeLayer.strokeEnd))
        inAnimation1.beginTime = startTime
        inAnimation1.fromValue = 0.0
        inAnimation1.toValue = 1.0
        inAnimation1.duration = duration
        inAnimation1.isRemovedOnCompletion = true
        inAnimation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        let outAnimation1 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
        outAnimation1.beginTime = startTime + 0.5
        outAnimation1.fromValue = 0.0
        outAnimation1.toValue = 1.0
        outAnimation1.duration = duration
        outAnimation1.isRemovedOnCompletion = true
        outAnimation1.timingFunction = CAMediaTimingFunction(name:  CAMediaTimingFunctionName.easeOut)
        
        let opacityAnimation1 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.opacity))
        opacityAnimation1.beginTime = 0.0
        opacityAnimation1.fromValue = 0.0
        opacityAnimation1.toValue = 0.0
        opacityAnimation1.duration = startTime
        opacityAnimation1.isRemovedOnCompletion = true
        opacityAnimation1.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let opacityAnimation2 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.opacity))
        opacityAnimation2.beginTime = startTime + duration
        opacityAnimation2.fromValue = 0.0
        opacityAnimation2.toValue = 0.0
        opacityAnimation2.duration = startTime + 30
        opacityAnimation2.isRemovedOnCompletion = true
        opacityAnimation2.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.0 + outAnimation1.beginTime
        strokeAnimationGroup.repeatCount = 1
        strokeAnimationGroup.delegate = self
        strokeAnimationGroup.animations = [inAnimation1, outAnimation1, opacityAnimation1]
        strokeAnimationGroup.isRemovedOnCompletion = true
        //strokeAnimationGroup.delegate = LayerRemover(for: shapeLayer)
        lighting.add(strokeAnimationGroup, forKey: #keyPath(CAShapeLayer.strokeEnd) )
    }
    
    
    
    
    func logoAnimate (path: UIBezierPath, color: UIColor, duration: Double, width: CGFloat){
       
        let shadowColor = ColorSystemHelper.primary
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: 8, height: 4)
        shadow.shadowBlurRadius = 5
        

        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        path.fill()
        context.restoreGState()
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.fillColor = nil
        self.layer.addSublayer(shapeLayer)

        let anim1 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd) )
        anim1.fromValue = 0
        anim1.toValue = 1
        anim1.duration = duration
        anim1.fillMode = CAMediaTimingFillMode.forwards
        anim1.isRemovedOnCompletion = false
        shapeLayer.add(anim1, forKey: #keyPath(CAShapeLayer.strokeEnd) )
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        runAnimate()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        lighting.opacity = 0
    }
}

