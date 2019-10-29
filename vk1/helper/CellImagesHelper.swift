import UIKit

class CellImagesHelper {

    //MARK: Dynamic Setup Image Plan for Cell
    
    static func configure(parentView: UIView, photoURLs: [String], imageViews: inout [PostImageView]){
        
        guard photoURLs.count > 0
            else { return }
        
        let screenWidth = UIScreen.main.bounds.width
        
        var maxCount = 9
        
        maxCount = min(maxCount, photoURLs.count)
        
        let (row, column, rem) = getImagePlan(count: maxCount)
        
        
        var hCon = ""
        var id = 0
        
        var views: [String: Any] = [:]
        var allConstraints: [NSLayoutConstraint] = []
        
        
        let height = parentView.frame.height/CGFloat(row)
        let width = screenWidth / CGFloat(column)
        
        
        id = 0
        for x in 0...row-1 {
            let top = x > 0 ? "\(id - column)" : ""
            hCon = "H:|"
            for _ in 0...column-1 {
                if id > maxCount-1 {
                    break
                }
                var mutableWidth = width
                // last row
                if x == row-1 && rem > 0 {
                    mutableWidth = screenWidth / CGFloat(rem)
                }
                hCon += getXConstraint(id, mutableWidth)
                fillView(parentView, &imageViews, id, mutableWidth, height, &views, photoURLs[id])
                allConstraints += getYConstraint(id, height, views, top)
                id+=1
            }
            //print(hCon)
            allConstraints += NSLayoutConstraint.constraints(
                withVisualFormat: hCon,
                metrics: nil,
                views: views)
        }
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    
    static func fillView(_ parentView: UIView, _ imageViews: inout [PostImageView], _ id: Int, _ width: CGFloat, _ height: CGFloat, _ views: inout [String: Any], _ photo: String){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.translatesAutoresizingMaskIntoConstraints = false
        let imageView = PostImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: photo)
        view.addSubview(imageView)
        parentView.addSubview(view)
        imageViews.append(imageView)
        views["view_\(id)"] = view
        
    }
    
    static func getYConstraint(_ viewId: Int, _ height: CGFloat, _ views: [String: Any], _ topView: String) -> [NSLayoutConstraint]{
        var topV = ""
        if topView != "" {
            topV = "[view_\(topView)]"
        }
        print("V:" + topV + "[view_\(viewId)(\(height))]")
        
        return NSLayoutConstraint.constraints(
            withVisualFormat: "V:" + topV + "[view_\(viewId)(\(height))]",
            metrics: nil,
            views: views)
        
    }
    
    static func getXConstraint(_ id: Int, _ width: CGFloat) -> String{
        return "[view_\(id)(\(width))]"
    }
    
    
    static func getImagePlan(count: Int) -> (Int, Int, Int) {
        let maxColumn: CGFloat = 3
        let row = ceil(CGFloat(count) / maxColumn)
        let column = Int(ceil(CGFloat(count) / row))
        print(abs((column * Int(row) - count)))
        let rem = Int(maxColumn) - abs((column * Int(row) - count))
        return (Int(row), column, rem == 3 ? 0 : rem)
    }
}
