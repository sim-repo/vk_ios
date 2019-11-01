import Foundation

public class WallPresenter: PlainBasePresenter {
    
    func datasourceIsEmpty() -> Bool {
        return dataSource.isEmpty
    }
    
    func sort(){
        if let walls = dataSource as? [Wall] {
            dataSource = walls.sorted {
                $0.origPostDate > $1.origPostDate
            }
        }
    }
    
    //MARK: override func
    override func validate(_ ds: [DecodableProtocol]) {
        guard ds is [Wall]
        else {
            catchError(msg: "WallPresenter: validate()")
            return
        }
    }
}


