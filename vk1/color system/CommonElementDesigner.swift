import UIKit


class CommonElementDesigner {
    
    static let likeControlAlpha: CGFloat = 1
    
    static var cellByCode = ["tp1": "Wall_Cell_tp1",
                             "tp2": "Wall_Cell_tp2",
                             "tp3": "Wall_Cell_tp3",
                             "tp4": "Wall_Cell_tp4",
                             "tp5": "Wall_Cell_tp5",
                             "tp6": "Wall_Cell_tp6",
                             "tp7": "Wall_Cell_tp7",
                             "tp8": "Wall_Cell_tp8",
                             "tp9": "Wall_Cell_tp9",]
    
    
    
    
    static func headerTableBuilder(view: UIView, title: UILabel) {
        title.textColor = ColorThemeHelper.onPrimary
        view.backgroundColor = ColorThemeHelper.primary
        view.alpha = ColorThemeHelper.sectionHeaderAlpha
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowColor = ColorThemeHelper.shadow.cgColor
        view.layer.shadowRadius = 2
    }
    
    static func headerBuilder(willDisplayHeaderView view: UIView) {
        let header = view as! UITableViewHeaderFooterView
        header.layer.shadowOpacity = 1
        header.layer.shadowOffset = CGSize(width: 0, height: 1)
        header.layer.shadowColor = ColorThemeHelper.shadow.cgColor
        header.layer.shadowRadius = 2
        
        header.textLabel?.textColor = ColorThemeHelper.onPrimary
        header.textLabel?.font = UIFont(name: "Courier New", size: 15)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = NSTextAlignment.left
        header.backgroundView?.backgroundColor = headerColor()
    }
    
    
    static func collectionCellBuilder(cell: UICollectionViewCell, title: UILabel?) {
        title?.textColor = ColorThemeHelper.onPrimary
        
        cell.contentView.layer.cornerRadius = 1
        cell.contentView.layer.borderWidth = 1.0

        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.backgroundColor = ColorThemeHelper.primary
        
        cell.layer.shadowColor = ColorThemeHelper.shadow.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    }
    

    
    private static func headerColor() -> UIColor {
        return ColorThemeHelper.primary
    }
    
    static func setupTabBarColor() {
        UITabBar.appearance().tintColor = ColorThemeHelper.secondary
        UITabBar.appearance().barTintColor = ColorThemeHelper.primary_soft_60
        UITabBar.appearance().unselectedItemTintColor = ColorThemeHelper.inactiveControls
        UITabBar.appearance().alpha = ColorThemeHelper.tabBarAlpha
    }
    
    static func setupNavigationBarColor(navigationController: UINavigationController?){
        
        let font = UIFont.systemFont(ofSize: 25)
        let shadow = NSShadow()
        shadow.shadowColor = ColorThemeHelper.background
        shadow.shadowBlurRadius = 15
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: ColorThemeHelper.titleOnPrimary,
            .shadow: shadow
        ]
        
        
        //let attributes = [NSAttributedString.Key.foregroundColor:ColorThemeHelper.titleOnPrimary]
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        var colors = [UIColor]()
        if (isDark) {
            colors.append(ColorThemeHelper.background)
            colors.append(ColorThemeHelper.primary)
            colors.append(ColorThemeHelper.background)
            navigationController?.navigationBar.tintColor = ColorThemeHelper.secondary
        } else {
            colors.append(ColorThemeHelper.primary)
            colors.append(ColorThemeHelper.background)
            colors.append(ColorThemeHelper.primary)
            navigationController?.navigationBar.tintColor = ColorThemeHelper.onPrimary
        }
        
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
    }
    
    
    static func setupLikeControl(like: UserActivityRegControl, likeCount: UILabel, message: UserActivityRegControl, eye: UserActivityRegControl, share: UserActivityRegControl, messageCount: UILabel, eyeCount: UILabel, shareCount: UILabel) {
        like.isUserInteractionEnabled = true
        message.isUserInteractionEnabled = true
        eye.isUserInteractionEnabled = true
        share.isUserInteractionEnabled = true
        
        like.alpha = CommonElementDesigner.likeControlAlpha
        message.alpha = CommonElementDesigner.likeControlAlpha
        eye.alpha = CommonElementDesigner.likeControlAlpha
        share.alpha = CommonElementDesigner.likeControlAlpha
        
        like.userActivityType = .like
        like.boundMetrics = likeCount
        message.userActivityType = .shake
        eye.userActivityType = .shake
        share.userActivityType = .shake
        
        
        likeCount.textColor = isDark ? ColorThemeHelper.secondary : ColorThemeHelper.primary
        messageCount.textColor = isDark ? ColorThemeHelper.secondary : ColorThemeHelper.primary
        eyeCount.textColor = isDark ? ColorThemeHelper.secondary : ColorThemeHelper.primary
        shareCount.textColor = isDark ? ColorThemeHelper.secondary : ColorThemeHelper.primary
        
        
        renderImage(imageView: like)
        renderImage(imageView: message)
        renderImage(imageView: eye)
        renderImage(imageView: share)
    }
    
    
    static func renderImage(imageView: UIImageView){
        if let image = imageView.image {
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            imageView.image = tintableImage
            imageView.tintColor = isDark ? ColorThemeHelper.secondary : ColorThemeHelper.primary
        }
    }
}
