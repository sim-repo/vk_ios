import Foundation

public class WallPresenter: PlainBasePresenter {
    
    func sort(){
        if let walls = dataSource as? [Wall] {
            dataSource = walls.sorted {
                $0.origPostDate > $1.origPostDate
            }
        }
    }
}


