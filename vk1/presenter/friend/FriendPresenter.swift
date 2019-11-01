import Foundation
import Alamofire

class FriendPresenter: HybridSectionedPresenter {
    
    var modelClass: AnyClass  {
        return Friend.self
    }
    
    //MARK: override func
    override func subscribe(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.addModel(_:)), name: .friendInserted, object: nil)
    }
    
//    override func validate(_ ds: [DecodableProtocol]) {
//        
//        
//        
//        print(String(describing: type(of: ds)))
//        
//        guard ds is [Friend]
//            else {
//                catchError(msg: "FriendPresenter: validate()")
//                return
//            }
//    }
}


extension FriendPresenter: BasicNetworkProtocol {
    func datasourceIsEmpty() -> Bool {
        return sortedDataSource.isEmpty
    }
}
