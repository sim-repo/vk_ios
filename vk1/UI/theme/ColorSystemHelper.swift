import UIKit

class ColorSystemHelper {
    
    static func setupDark() {
        isDark = true
        background = #colorLiteral(red: 0.005808433518, green: 0.00166301534, blue: 0.262986809, alpha: 1)
        topBackground = tint(color: background, tint: 0)
        bottomBackground = tint(color: background, tint: -220)
        onBackground = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let primary_color = #colorLiteral(red: 0.4392291903, green: 0.1222558096, blue: 0.9621943831, alpha: 1)
        let secondary_color =  #colorLiteral(red: 0, green: 0.9903071523, blue: 0.4053229094, alpha: 1)
        onPrimary = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        onSecondary = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        shadow = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) // #colorLiteral(red: 0, green: 0.5730010867, blue: 0.556679666, alpha: 1)
        inactiveControls = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        titleOnPrimary = #colorLiteral(red: 0, green: 0.9903071523, blue: 0.4053229094, alpha: 1)
        tabBarAlpha = 0.8
            
        primary_r = 255*primary_color.rgba.red
        primary_g = 255*primary_color.rgba.green
        primary_b = 255*primary_color.rgba.blue
        
        secondary_r = 255*secondary_color.rgba.red
        secondary_g = 255*secondary_color.rgba.green
        secondary_b = 255*secondary_color.rgba.blue
        
       
        
        primary_contrast_30 = ColorSystemHelper.primary(tint: 30)
        primary_contrast_60 = ColorSystemHelper.primary(tint: 60)
        primary_contrast_90 = ColorSystemHelper.primary(tint: 90)
        primary_contrast_120 = ColorSystemHelper.primary(tint: 120)
        primary = ColorSystemHelper.primary(alpha: 1)
        primary_soft_30 = ColorSystemHelper.primary(tint: -30)
        primary_soft_60 = ColorSystemHelper.primary(tint: -60)
        primary_soft_90 = ColorSystemHelper.primary(tint: -90)
        primary_soft_120 = ColorSystemHelper.primary(tint: -120)
        
        secondary_constrast_30 = ColorSystemHelper.secondary(tint: 30)
        secondary_constrast_60 = ColorSystemHelper.secondary(tint: 60)
        secondary_constrast_90 = ColorSystemHelper.secondary(tint: 90)
        secondary_constrast_120 = ColorSystemHelper.secondary(tint: 120)
        secondary = ColorSystemHelper.secondary(alpha: 1)
        secondary_soft_30 = ColorSystemHelper.secondary(tint: -30)
        secondary_soft_60 = ColorSystemHelper.secondary(tint: -60)
        secondary_soft_90 = ColorSystemHelper.secondary(tint: -90)
        secondary_soft_120 = ColorSystemHelper.secondary(tint: -120)
 
    }
    
    
    
    
    static func setupLight() {
        isDark = false
        background = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        topBackground = tint(color: background, tint: 30)
        bottomBackground = tint(color: background, tint: -70)
        onBackground = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let primary_color = #colorLiteral(red: 0.1408204734, green: 0.6550927758, blue: 0.7994835973, alpha: 1)
        let secondary_color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        onPrimary = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        onSecondary = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        shadow = #colorLiteral(red: 0.1490205228, green: 0.1489917934, blue: 0.1532951891, alpha: 1)
        inactiveControls = #colorLiteral(red: 0.1490205228, green: 0.1489917934, blue: 0.1532951891, alpha: 1)
        titleOnPrimary = #colorLiteral(red: 0.06316316873, green: 0.06318188459, blue: 0.06316071004, alpha: 1)
        tabBarAlpha = 1
        
        primary_r = 255*primary_color.rgba.red
        primary_g = 255*primary_color.rgba.green
        primary_b = 255*primary_color.rgba.blue

        secondary_r = 255*secondary_color.rgba.red
        secondary_g = 255*secondary_color.rgba.green
        secondary_b = 255*secondary_color.rgba.blue

        primary_contrast_30 = ColorSystemHelper.primary(tint: -30)
        primary_contrast_60 = ColorSystemHelper.primary(tint: -60)
        primary_contrast_90 = ColorSystemHelper.primary(tint: -90)
        primary_contrast_120 = ColorSystemHelper.primary(tint: -120)
        primary = ColorSystemHelper.primary(alpha: 1)
        primary_soft_30 = ColorSystemHelper.primary(tint: 30)
        primary_soft_60 = ColorSystemHelper.primary(tint: 60)
        primary_soft_90 = ColorSystemHelper.primary(tint: 90)
        primary_soft_120 = ColorSystemHelper.primary(tint: 120)
        
        secondary_constrast_30 = ColorSystemHelper.secondary(tint: -30)
        secondary_constrast_60 = ColorSystemHelper.secondary(tint: -60)
        secondary_constrast_90 = ColorSystemHelper.secondary(tint: -90)
        secondary_constrast_120 = ColorSystemHelper.secondary(tint: -120)
        secondary = ColorSystemHelper.secondary(alpha: 1)
        secondary_soft_30 = ColorSystemHelper.secondary(tint: 30)
        secondary_soft_60 = ColorSystemHelper.secondary(tint: 60)
        secondary_soft_90 = ColorSystemHelper.secondary(tint: 90)
        secondary_soft_120 = ColorSystemHelper.secondary(tint: 120)
        
        
    }
    
    
    
    
    static var background = UIColor.white
    static var topBackground = UIColor.white
    static var bottomBackground = UIColor.white
    static var onBackground = UIColor.black
    
    static var shadow = UIColor.white
    static var primary_r: CGFloat  = 0
    static var primary_g: CGFloat  = 0
    static var primary_b: CGFloat  = 0
    
    static var secondary_r: CGFloat  = 0
    static var secondary_g: CGFloat  = 0
    static var secondary_b: CGFloat  = 0
    

    static var onPrimary = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static var titleOnPrimary = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    
    static var primary_contrast_30 = ColorSystemHelper.primary(tint: 30)
    static var primary_contrast_60 = ColorSystemHelper.primary(tint: 60)
    static var primary_contrast_90 = ColorSystemHelper.primary(tint: 90)
    static var primary_contrast_120 = ColorSystemHelper.primary(tint: 120)
    static var primary = ColorSystemHelper.primary(alpha: 1)
    static var primary_soft_30 = ColorSystemHelper.primary(tint: -30)
    static var primary_soft_60 = ColorSystemHelper.primary(tint: -60)
    static var primary_soft_90 = ColorSystemHelper.primary(tint: -90)
    static var primary_soft_120 = ColorSystemHelper.primary(tint: -120)
    
    static var onSecondary = UIColor.black
    
    static var secondary_constrast_30 = ColorSystemHelper.secondary(tint: 30)
    static var secondary_constrast_60 = ColorSystemHelper.secondary(tint: 60)
    static var secondary_constrast_90 = ColorSystemHelper.secondary(tint: 90)
    static var secondary_constrast_120 = ColorSystemHelper.secondary(tint: 120)
    static var secondary = ColorSystemHelper.secondary(alpha: 1)
    static var secondary_soft_30 = ColorSystemHelper.secondary(tint: 30)
    static var secondary_soft_60 = ColorSystemHelper.secondary(tint: 60)
    static var secondary_soft_90 = ColorSystemHelper.secondary(tint: 90)
    static var secondary_soft_120 = ColorSystemHelper.secondary(tint: 120)

    
    static let sectionHeaderAlpha: CGFloat = 0.95
    static var tabBarAlpha: CGFloat = 1
    static var inactiveControls = #colorLiteral(red: 0.2562765479, green: 0.2563257515, blue: 0.256270051, alpha: 1)
    
    
    
    static func primary(alpha: CGFloat) ->  UIColor {
        return  UIColor(displayP3Red: ColorSystemHelper.primary_r/255, green: ColorSystemHelper.primary_g/255, blue: ColorSystemHelper.primary_b/255, alpha: alpha)
    }
    
    static func primary(tint: CGFloat) ->  UIColor {
        return  UIColor(displayP3Red: (ColorSystemHelper.primary_r+tint)/255, green: (ColorSystemHelper.primary_g+tint)/255, blue: (ColorSystemHelper.primary_b+tint)/255, alpha: 1)
    }
  
    
    static func secondary(alpha: CGFloat) ->  UIColor {
          return  UIColor(displayP3Red: ColorSystemHelper.secondary_r/255, green: ColorSystemHelper.secondary_g/255, blue: ColorSystemHelper.secondary_b/255, alpha: alpha)
      }
      
    static func secondary(tint: CGFloat) ->  UIColor {
      return  UIColor(displayP3Red: (ColorSystemHelper.secondary_r+tint)/255, green: (ColorSystemHelper.secondary_g+tint)/255, blue: (ColorSystemHelper.secondary_b+tint)/255, alpha: 1)
    }
    
    static func tint(color: UIColor, tint: CGFloat) ->  UIColor {
        let r = 255*color.rgba.red
        let g = 255*color.rgba.green
        let b = 255*color.rgba.blue
        return  UIColor(displayP3Red: (r + tint)/255, green: (g + tint)/255, blue: (b + tint)/255, alpha: 1)
    }
}


extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}
