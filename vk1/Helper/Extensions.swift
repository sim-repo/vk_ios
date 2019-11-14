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

func UI_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.main.async(execute: block)
}


func BKG_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.global(qos: .background).async(execute: block)
}

func DELAY_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(networkDelayBetweenRequests), qos: .background){
        block()
    }
}

func LDELAY_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(networkLongDelayBetweenRequests), qos: .background){
        block()
    }
}


func isRowPresentInTableView(indexPath: IndexPath, tableView: UITableView) -> Bool{
    if indexPath.section < tableView.numberOfSections{
        if indexPath.row < tableView.numberOfRows(inSection: indexPath.section){
            return true
        }
    }

    return false
}

func catchError(msg: String){
    #if DEBUG
        print("----------------------")
        print("ERROR: " + msg)
        print("----------------------")
        //fatalError()
    #else
        sendCrashlytics(msg)
    #endif
}


func sendCrashlytics(_ msg: String) {
    //TODO
}

func convertUnixTime(unixTime: Double) -> String {
    let date = Date(timeIntervalSince1970: unixTime)
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.medium
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeZone = .current
    return dateFormatter.string(from: date)
}


func console(msg: String) {
    #if DEBUG
        print(msg)
        print()
    #else
           logInf(msg)
    #endif
}

func logInf(msg: String) {
    //TODO
}


extension Int
{
    func toString() -> String
    {
        let myString = String(self)
        return myString
    }
}



func getRawClassName(object: AnyClass) -> String {
    
    let name = NSStringFromClass(object)
    let components = name.components(separatedBy: ".")
    return components.last ?? "Unknown"
}


extension UITextView {
    func actualSize() -> CGSize {
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        return frame.size
    }
}
