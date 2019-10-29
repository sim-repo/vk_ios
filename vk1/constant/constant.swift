import UIKit


enum LoadModelType{
    case networkFirst
    case diskFirst
}


enum FriendGroupByType: String {
    case firstName = "По Имени"
    case lastName = "По Фамилии"
}


enum FriendImagesType: Int {
   case image50
   case image200
}


enum MyGroupByType: String {
    case name = "По Названию"
}


enum GroupImagesType: Int{
    case image50
    case image200
}

enum WallImagesType: Int{
    case m
    case l
}


func getImagePlanCode(imageCount: Int) -> String {
    switch imageCount {
        case 1: return "tp1"
        case 2: return "tp2"
        case 3: return "tp3"
        case 4: return "tp4"
        case 5: return "tp5"
        case 6: return "tp6"
        case 7: return "tp7"
        case 8: return "tp8"
        case 9: return "tp9"
        default:
            return "tp9"
    }
}

var cellByCode = ["tp1": "Wall_Cell_tp1",
                 "tp2": "Wall_Cell_tp2",
                 "tp3": "Wall_Cell_tp3",
                 "tp4": "Wall_Cell_tp4",
                 "tp5": "Wall_Cell_tp5",
                 "tp6": "Wall_Cell_tp6",
                 "tp7": "Wall_Cell_tp7",
                 "tp8": "Wall_Cell_tp8",
                 "tp9": "Wall_Cell_tp9"]


var cellHeaderHeight: CGFloat = 120
var cellQuarterHeight: CGFloat = 120 / 4
var cellImageHeight: CGFloat = 220
var cellBottomHeight: CGFloat = 30

extension Notification.Name {
    static let friendInserted = Notification.Name("friendInserted")
    static let groupInserted = Notification.Name("groupInserted")
}


