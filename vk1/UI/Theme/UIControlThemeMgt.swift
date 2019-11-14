import UIKit


class UIControlThemeMgt {
    
    static let likeControlAlpha: CGFloat = 1
    

    
    
    static func setupTableHeader(view: UIView, title: UILabel) {
        title.textColor = ColorSystemHelper.onPrimary
        view.backgroundColor = ColorSystemHelper.primary
        view.alpha = ColorSystemHelper.sectionHeaderAlpha
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowColor = ColorSystemHelper.shadow.cgColor
        view.layer.shadowRadius = 2
    }
    
    static func setupTableHeader(willDisplayHeaderView view: UIView) {
        let header = view as! UITableViewHeaderFooterView
        header.layer.shadowOpacity = 1
        header.layer.shadowOffset = CGSize(width: 0, height: 1)
        header.layer.shadowColor = ColorSystemHelper.shadow.cgColor
        header.layer.shadowRadius = 2
        
        header.textLabel?.textColor = ColorSystemHelper.onPrimary
        header.textLabel?.font = UIFont(name: "Courier New", size: 15)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = NSTextAlignment.left
        header.backgroundView?.backgroundColor = headerColor()
    }
    
    
    static func setupCollectionCell(cell: UICollectionViewCell, title: UILabel?) {
        title?.textColor = ColorSystemHelper.onPrimary
        
        cell.contentView.layer.cornerRadius = 1
        cell.contentView.layer.borderWidth = 1.0

        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.backgroundColor = ColorSystemHelper.primary
        
        cell.layer.shadowColor = ColorSystemHelper.shadow.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    }
    
    static func setupTabBarColor() {
        UITabBar.appearance().tintColor = ColorSystemHelper.secondary
        UITabBar.appearance().barTintColor = ColorSystemHelper.primary_soft_60
        UITabBar.appearance().unselectedItemTintColor = ColorSystemHelper.inactiveControls
        UITabBar.appearance().alpha = ColorSystemHelper.tabBarAlpha
    }
    
    
    static func setupNavigationBarColor(navigationController: UINavigationController?){
        
        
        guard let font = UIFont(name: "Arcade", size: 30) else {
            fatalError("""
                Failed to load the "Arcade" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
     
        
        //let font = UIFont.systemFont(ofSize: 18)
        let shadow = NSShadow()
        shadow.shadowColor = ColorSystemHelper.background
        shadow.shadowBlurRadius = 15
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: ColorSystemHelper.titleOnPrimary,
            .shadow: shadow
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        var colors = [UIColor]()
        if (isDark) {
            colors.append(ColorSystemHelper.background)
            colors.append(ColorSystemHelper.primary)
            colors.append(ColorSystemHelper.background)
            navigationController?.navigationBar.tintColor = ColorSystemHelper.secondary
        } else {
            colors.append(ColorSystemHelper.primary)
            colors.append(ColorSystemHelper.background)
            colors.append(ColorSystemHelper.primary)
            navigationController?.navigationBar.tintColor = ColorSystemHelper.onPrimary
        }
        
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
    }
    
    
    static func setupLikeControl(like: PostImageView, likeCount: UILabel, message: PostImageView, eye: PostImageView, share: PostImageView, messageCount: UILabel, eyeCount: UILabel, shareCount: UILabel) {
        like.isUserInteractionEnabled = true
        message.isUserInteractionEnabled = true
        eye.isUserInteractionEnabled = true
        share.isUserInteractionEnabled = true
        
        like.alpha = UIControlThemeMgt.likeControlAlpha
        message.alpha = UIControlThemeMgt.likeControlAlpha
        eye.alpha = UIControlThemeMgt.likeControlAlpha
        share.alpha = UIControlThemeMgt.likeControlAlpha
        
        like.userActivityType = .like
        like.boundMetrics = likeCount
        message.userActivityType = .shake
        eye.userActivityType = .shake
        share.userActivityType = .shake
        
        
        likeCount.textColor = isDark ? ColorSystemHelper.secondary : ColorSystemHelper.primary
        messageCount.textColor = isDark ? ColorSystemHelper.secondary : ColorSystemHelper.primary
        eyeCount.textColor = isDark ? ColorSystemHelper.secondary : ColorSystemHelper.primary
        shareCount.textColor = isDark ? ColorSystemHelper.secondary : ColorSystemHelper.primary
        
        
        renderImage(imageView: like)
        renderImage(imageView: message)
        renderImage(imageView: eye)
        renderImage(imageView: share)
    }
    
    
    static func renderImage(imageView: UIImageView){
        if let image = imageView.image {
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            imageView.image = tintableImage
            imageView.tintColor = isDark ? ColorSystemHelper.secondary : ColorSystemHelper.primary
        }
    }
    
    private static func headerColor() -> UIColor {
           return ColorSystemHelper.primary
    }
}

