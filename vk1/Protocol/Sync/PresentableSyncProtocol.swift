import UIKit
import WebKit

// presenter get access to sync: declarative
protocol PresentableSyncProtocol: class {
    func tryRunSync()
}

//MARK: - Specific Protocols
protocol PresentableLoginSyncProtocol: class {
    func tryAuth(webview: WKWebView)
    func tryCheckToken(token: String, _ onChecked: ((Bool)->Void)?)
}

protocol PresentableGroupSyncProtocol: class {
    func tryJoin(groupId: String)
    func trySearch(filter: String)
}

protocol PresentableVideoSyncProtocol: class {
    func tryVideoGet(postId: Int, ownerId: Int, _ onSuccess: ((URL, WallCellConstant.VideoPlatform) -> Void)?, _ onError: ((String)->Void)? )
    func tryVideoSearch(q: String, _ onSuccess: ((URL, WallCellConstant.VideoPlatform) -> Void)?, _ onError: ((String)->Void)?)
}
