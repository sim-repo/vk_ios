import UIKit


@IBDesignable class RoundedImage: UIView {
    
    var image: UIImage? = UIImage() {
        willSet{
            imageView.image? = newValue!
        }
    }
    
    
    var imageView = UIImageView()
    
    @IBInspectable var noRenderedImageView: UIImage? {
       willSet{
           self.imageView.image = newValue
       }
    }
    
    var drawOnPrimary = 0
    
   @IBInspectable var onPrimary: Int = 0 {
            willSet{
                drawOnPrimary = newValue
            }
         }
    
    @IBInspectable var renderedImageView: UIImage? {
        willSet{
            self.imageView.image = newValue
            imageView.contentMode = .scaleAspectFit
            
            UIControlThemeMgt.renderImage(imageView: imageView)
        }
    }
    
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        willSet{
            if newValue != 0  {
                self.layer.cornerRadius = self.layer.bounds.height/2
            } else {
                self.layer.cornerRadius = self.layer.bounds.height/2
                
            }
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .black {
        didSet{
            changeShadowColor()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            cahngeShadowOpacity()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 20 {
        didSet{
            changeShadowRadius()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet{
            changeShadowOffset()
        }
    }
    
    private func changeShadowColor(){
        self.layer.shadowColor = self.shadowColor.cgColor
    }
    
    private func cahngeShadowOpacity(){
        self.layer.shadowOpacity = self.shadowOpacity
    }
    
    private func changeShadowRadius(){
        self.layer.shadowRadius = self.shadowRadius
    }
    
    private func changeShadowOffset(){
        self.layer.shadowOffset = self.shadowOffset
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.layer.masksToBounds = false
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = self.layer.bounds.height/2
        self.shadow()
        self.setImage()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        self.contentMode = .scaleAspectFill
        if (self.drawOnPrimary != 0) {
            backgroundColor = ColorSystemHelper.primary
        } else {
            backgroundColor = .clear
        }
       // backgroundColor = ColorThemeHelper.primary
        self.setImage()
        self.shadow()
    }
    
    func shadow() {
        self.changeShadowColor()
        self.changeShadowOffset()
        self.changeShadowRadius()
        self.cahngeShadowOpacity()
    }
    
    private func setImage() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        imageView.image = self.image
        if (cornerRadius != 0) {
            let roundMask = CAShapeLayer()
            let round = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
            roundMask.path = round.cgPath
            imageView.layer.mask = roundMask
            imageView.contentMode = .scaleAspectFill
        }
        self.addSubview(imageView)
    }
}
