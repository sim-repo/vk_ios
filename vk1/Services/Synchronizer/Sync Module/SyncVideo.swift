import UIKit

class SyncVideo {
    
    public static func doVideoGet(postId: Int, ownerId: Int, _ onSuccess: ((URL, WallCellConstant.VideoPlatform)->Void)?, _ onError: ((String)->Void)? ) {
         ApiVKService.videoRequest(postId: postId, ownerId: ownerId, onSuccess, onError )
    }
    
    public static func doVideoSearch(q: String, _ onSuccess: ((URL, WallCellConstant.VideoPlatform)->Void)?, _ onError: ((String)->Void)?) {
         ApiVKService.videoSearchRequest(q: q, onSuccess, onError)
    }
}

