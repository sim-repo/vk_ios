import UIKit



class MyView_Background : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorThemeHelper.background
    }
}

class MyView_GradiendBackground : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let topColor: UIColor = ColorThemeHelper.topBackground
        let bottomColor: UIColor = ColorThemeHelper.bottomBackground
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
        setTitleColor(ColorThemeHelper.secondary, for: .normal)
    }
}

class MyButton_Adaptive : UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if (isDark) {
            setTitleColor(ColorThemeHelper.secondary, for: .normal)
        } else {
            setTitleColor(ColorThemeHelper.primary, for: .normal)
        }
    }
}


class MyTitle_OnPrimary : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorThemeHelper.titleOnPrimary
    }
}


class MyLabel_OnBackground : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorThemeHelper.onBackground
    }
}

class MyLabel_OnPrimary : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorThemeHelper.onPrimary
    }
}


class MyLabel_Adaptive : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if (isDark) {
            textColor = ColorThemeHelper.secondary
              } else {
            textColor = ColorThemeHelper.primary_contrast_30
        }
    }
}

class MyLabel_Secondary : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorThemeHelper.secondary
    }
}


class MyLabel_Secondary_Soft_120 : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorThemeHelper.secondary_soft_120
    }
}

class MyLabel_Secondary_Contrast_60 : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorThemeHelper.secondary_constrast_60
    }
}

class MyLabel_Secondary_Contrast_120 : UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorThemeHelper.secondary_constrast_120
    }
}


class MyTextView_OnBackground : UITextView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorThemeHelper.onBackground
    }
}


class MyTextView_OnPrimary : UITextView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = ColorThemeHelper.onPrimary
    }
}



class MyImageView_Primary : UIImageView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        renderImage(imageView: self)
    }
    
    func renderImage(imageView: UIImageView){
        if let image = imageView.image {
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            imageView.image = tintableImage
            imageView.tintColor = ColorThemeHelper.primary
        }
    }
}


class MyImageView_Secondary : UIImageView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if (!isDark) {
            backgroundColor = ColorThemeHelper.primary
        }
        renderImage(imageView: self)
    }
    
    func renderImage(imageView: UIImageView){
        if let image = imageView.image {
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            imageView.image = tintableImage
            imageView.tintColor = ColorThemeHelper.secondary
        }
    }
}


class MyTextField_Secondary : UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorThemeHelper.secondary_soft_120
    }
}



class MyView_Primary : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorThemeHelper.primary
    }
}

class MyView_Secondary: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorThemeHelper.secondary
    }
}


class MyView_SecondaryDark : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorThemeHelper.secondary_constrast_120
    }
}








