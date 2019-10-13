import UIKit

internal enum Direction {
    case up
    case down
    case left
    case right
}

//MARK: - UIPanGestureRecognizer
internal extension UIPanGestureRecognizer {
    var direction: Direction? {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)

        switch (isVertical, velocity.x, velocity.y) {
            case (true, _, let y) where y < 0: return .up
            case (true, _, let y) where y > 0: return .down
            case (false, let x, _) where x > 0: return .right
            case (false, let x, _) where x < 0: return .left
            default: return nil
        }
    }
}


var wScreen: CGFloat {
    return UIScreen.main.bounds.size.width
}

var hScreen: CGFloat {
    return UIScreen.main.bounds.size.height
}

var wHalfScreen: CGFloat {
    return UIScreen.main.bounds.size.width/2.0
}

var hHalfScreen: CGFloat {
    return UIScreen.main.bounds.size.height/2.0
}

func renderImage(imageView: UIImageView, color: UIColor) {
   if let image = imageView.image {
       let tintableImage = image.withRenderingMode(.alwaysTemplate)
       imageView.image = tintableImage
       imageView.tintColor = color
   }
}

//func getRenderedImage(image: UIImage) -> UIImage {
//    let tintableImage = image.withRenderingMode(.alwaysTemplate)
//    tintableImage.tin
//       imageView.image = tintableImage
//       imageView.tintColor = ColorSystemHelper.primary
//
//}

