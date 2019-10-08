import UIKit



class MyView_Background : UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = ColorThemeHelper.background
    }
}


class MyButton_Secondary : UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTitleColor(ColorThemeHelper.secondary, for: .normal)
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


class MyImageView_Secondary : UIImageView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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








