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
        fatalError(msg)
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
        print()
        print()
        print("----------------------------------------------------------------------")
        print(msg)
        print("----------------------------------------------------------------------")
        print()
        print()
    #else
           logInf(msg)
    #endif
}

func logInf(msg: String) {
    //TODO
}
