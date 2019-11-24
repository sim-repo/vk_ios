import UIKit

class SyncFriendWall2: SyncA {
    
    
    static let shared = SyncFriendWall2()
    private override init() {}
    
    var module: ModuleEnum {
        return .friend_wall
    }
    
    var detailId = 0
    
    var id: typeId {
        get {
            return detailId
        }
        set {
            detailId = newValue
        }
    }
    
    var offById: [typeId : Int] = [:]
    
    var offsetById: [typeId : Int] {
        get {
            return offById
        }
        set {
            offById = newValue
        }
    }
}


extension SyncFriendWall2: SyncChild_OwnOffset_DetailId {

    
    func getOffsetCompletion(id: typeId) -> (() -> Void)? {
         return { [weak self] in
                   self?.incrementOffset(id: id)}
    }
    
    func incrementOffset(id: Int) {
        if offById[id] == nil {
            offById[id] = Network.wallResponseItemsPerRequest
        } else {
            offById[id]! += Network.wallResponseItemsPerRequest
        }
    }
    
    func getOwnOffset(id: typeId) -> Int {
        return offsetById[id]  ?? 0
    }
    
    func loadModelFromRealm(ownOffset: Int) -> [DecodableProtocol]? {
        return RealmService.loadWall(filter: "offset = \(ownOffset) AND ownerId = \(id)")
    }
    
    func apiRequest(_ ownOffset: Int,
                    _ count: Int,
                    _ onSuccess: @escaping onSuccess_PresenterCompletion,
                    _ onError: @escaping onErrResponse_SyncCompletion,
                    _ offsetCompletion: (() -> Void)?,
                    _ sinceTime: Double?) {

        
        ApiVK.friendWallRequest(id,
                                ownOffset,
                                count,
                                onSuccess,
                                onError,
                                offsetCompletion)
    }
    

    
    func getLastPostDate() -> Int? {
        return RealmService.newsLastPostDate()
    }
    
    
    
    
    
    
    
    
//
//
//    var module: ModuleEnum {
//        return .friend_wall
//    }
//
//    func getLastPostDate() -> Int? {
//        return RealmService.newsLastPostDate()
//    }
//
//    func loadModelFromRealm(ownOffset: Int) -> [DecodableProtocol]? {
//        return RealmService.loadWall(filter: "ownOffset = \(ownOffset)")
//    }
//
//    func apiRequest(_ ownOffset: Int,
//                    _ serverOffset: String?,
//                    _ count: Int,
//                    _ onSuccess: @escaping onSuccess_PresenterCompletion,
//                    _ onError: @escaping onErrResponse_SyncCompletion,
//                    _ offsetCompletion: ((String) -> Void)?,
//                    _ sinceTime: Double?) {
//
//        guard let srvOffset = serverOffset
//            else {
//                catchError(msg: "SyncNews(): apiRequest() serverOffset is nil")
//                return
//        }
//
//        ApiVK.newsRequest(ownOffset,
//                          srvOffset,
//                          Network.newsResponseItemsPerRequest,
//                          onSuccess,
//                          onError,
//                          offsetCompletion,
//                          sinceTime
//        )
 //   }
}
