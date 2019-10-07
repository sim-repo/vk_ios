import UIKit

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
    
        bounds.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: bounds, colors: colors)
        
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}
