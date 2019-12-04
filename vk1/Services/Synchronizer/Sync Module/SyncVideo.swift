import UIKit

class SyncVideo {
    
    public static func doVideoGet(postId: Int, ownerId: Int, completion: ((URL, WallCellConstant.VideoPlatform)->Void)?) {
         ApiVKService.videoRequest(postId: postId, ownerId: ownerId, completion: completion )
    }
    
    public static func doVideoSearch(q: String, completion: ((URL, WallCellConstant.VideoPlatform)->Void)?) {
         ApiVKService.videoSearchRequest(q: q, completion: completion )
    }
}

