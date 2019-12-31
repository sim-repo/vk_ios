import UIKit

//MARK: - screen

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


//MARK: - UIPanGestureRecognizer

internal enum Direction {
    case up
    case down
    case left
    case right
}


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





//MARK:- THREAD

//PRESENTERS:

func PRESENTER_UI_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.main.async(execute: block)
}


private let concurrentQueue = DispatchQueue(label: "", attributes: .concurrent)

func THREAD_SAFETY(_ block: @escaping (() -> Void)) {
    concurrentQueue.async(flags: .barrier, execute: block)
}




//NETWORK LAYER:

func SYNC_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.global(qos: .userInitiated).async(execute: block)
}


func NET_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.global(qos: .background).async(execute: block)
}

func NET_DELAY_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(NetworkConstant.delayBetweenRequests), qos: .background){
        block()
    }
}

func NET_LDELAY_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(NetworkConstant.longDelayBetweenRequests), qos: .background){
        block()
    }
}


//SOME:
func DELAY_THREAD(sec: Int, _ block: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(sec), qos: .userInteractive){
        block()
    }
}




//MARK: - MISC

func isRowPresentInTableView(indexPath: IndexPath, tableView: UITableView) -> Bool{
    if indexPath.section < tableView.numberOfSections{
        if indexPath.row < tableView.numberOfRows(inSection: indexPath.section){
            return true
        }
    }
    return false
}


func convertUnixTime(unixTime: Double) -> String {
    let date = Date(timeIntervalSince1970: unixTime)
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.medium
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeZone = .current
    return dateFormatter.string(from: date)
}

func timestampToDate(timestamp: Double) -> Date {
    return Date(timeIntervalSince1970: timestamp)
}

func getUnixTime(date: Date) -> Int {
    return Int(date.timeIntervalSince1970)
}



func getRawClassName(object: AnyClass) -> String {
    
    let name = NSStringFromClass(object)
    let components = name.components(separatedBy: ".")
    return components.last ?? "Unknown"
}


func renderImage(imageView: UIImageView, color: UIColor) {
    if let image = imageView.image {
        let tintableImage = image.withRenderingMode(.alwaysTemplate)
        imageView.image = tintableImage
        imageView.tintColor = color
    }
}

func getRealmURL(dbName: String) -> URL {
    let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                         appropriateFor: nil, create: false)
    return documentDirectory.appendingPathComponent("\(dbName).realm")
}

func getRandomInt() -> Int {
    return Int(arc4random_uniform(UInt32(1000000)))
}


func getSystemImage(name: String, pointSize: CGFloat) -> UIImage?{
    let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .light, scale: .large)
    return UIImage(systemName: name, withConfiguration: config)?.withTintColor(ColorSystemHelper.secondary, renderingMode: .alwaysOriginal)
}


//MARK:- Extensions

extension Int {
    func toString() -> String
    {
        let myString = String(self)
        return myString
    }
}


//MARK: - DEBUG ONLY

func printFonts() {
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("Family: \(family) Font names: \(names)")
    }
}

