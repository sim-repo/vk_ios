import Foundation
import Alamofire

public class FriendPresenter: SectionedBasePresenter {
    
    //MARK: override func
    override func subscribe(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.addModel(_:)), name: .friendInserted, object: nil)
    }
    
    override func validate(_ ds: [DecodableProtocol]) {
        guard ds is [Friend]
            else {
                catchError(msg: "FriendPresenter: validate()")
                return
            }
    }
}


extension FriendPresenter: BasicNetworkProtocol {
    func datasourceIsEmpty() -> Bool {
        return sortedDataSource.isEmpty
    }
}
