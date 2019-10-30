import UIKit




class MyView_GradiendBackground : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let topColor: UIColor = ColorSystemHelper.topBackground
        let bottomColor: UIColor = ColorSystemHelper.bottomBackground
        let layer = self.layer as! CAGradientLayer
        layer.colors = [topColor, bottomColor].map{$0.cgColor}
        layer.startPoint = CGPoint(x: 0.5, y: isDark ? 0.6: 0.7)
        layer.endPoint = CGPoint (x: 0.5, y: 1)
    }
    
    override class var layerClass: AnyClass {
       get {
           return CAGradientLayer.self
       }
   }
}


class MyButton_Secondary : UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTitleColor(ColorSystemHelper.secondary, for: .normal)
    }
}

class MyButton_Adaptive : UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if (isDark) {
            if currentImage != nil {
              tintColor = ColorSystemHelper.secondary
            }
            setTitleColor(ColorSystemHelper.secondary, for: .normal)
        } else {
            if currentImage != nil {
              tintColor = ColorSystemHelper.primary
            }
            setTitleColor(ColorSystemHelper.primary, for: .normal)
        }
    }
}


class MyTitle_OnPrimary : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorSystemHelper.titleOnPrimary
    }
}


class MyLabel_OnBackground : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorSystemHelper.onBackground
    }
}

class MyLabel_OnPrimary : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorSystemHelper.onPrimary
    }
}


class MyLabel_Adaptive : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if (isDark) {
            textColor = ColorSystemHelper.secondary
              } else {
            textColor = ColorSystemHelper.primary_contrast_30
        }
    }
}

class MyLabel_Secondary : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorSystemHelper.secondary
    }
}


class MyLabel_Secondary_Soft_120 : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorSystemHelper.secondary_soft_120
    }
}

class MyLabel_Secondary_Contrast_60 : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorSystemHelper.secondary_constrast_60
    }
}

class MyLabel_Secondary_Contrast_120 : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorSystemHelper.secondary_constrast_120
    }
}


class MyTextView_OnBackground : UITextView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorSystemHelper.onBackground
    }
}


class MyTextView_OnPrimary : UITextView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorSystemHelper.onPrimary
    }
}



class MyImageView_Primary : UIImageView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        renderImage(imageView: self, color: ColorSystemHelper.primary)
    }
}


class MyImageView_Secondary : UIImageView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if (!isDark) {
            backgroundColor = ColorSystemHelper.primary
        }
        renderImage(imageView: self, color: ColorSystemHelper.secondary)
    }
}


class MyImageView_DarkPrimary : UIImageView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = ColorSystemHelper.bottomBackground
    }
}

class MyTextField_Secondary : UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorSystemHelper.secondary_soft_120
    }
}



class MyView_Primary : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorSystemHelper.primary
    }
}

class MyView_Secondary: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorSystemHelper.secondary
    }
}


class MyView_SecondaryDark : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorSystemHelper.secondary_constrast_120
    }
}

class MyView_Background : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorSystemHelper.background
    }
}


class MyView_DarkBackground : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorSystemHelper.midBottomBackground
    }
}


extension UINavigationBar {
    func setGradientBackground(colors: [UIColor]) {
        bounds.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: bounds, colors: colors)
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}


extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 0)
    }
    
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
