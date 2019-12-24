import UIKit


class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }
}


extension UITextView {
    
    func actualSize() -> CGSize {
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        return frame.size
    }
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.actualSize().height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
    func lineHeight() -> CGFloat {
        return font?.lineHeight ?? 0
    }
    
    func sizeForLines(numberOfLines: Int) -> CGFloat {
        return 30 + CGFloat(numberOfLines)*lineHeight()
    }
    
}
