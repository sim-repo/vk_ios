import UIKit

class NewsPresenter: PlainPresenterProtocols {
    
    var netFinishViewReload: Bool = false
    
    var modelClass: AnyClass  {
        return News.self
    }
    
    var expandedIndexesPath: [IndexPath] = []
    
    var precalculatedCellHeights = [CGFloat]()
    
    var postText = CGRect(x: 0.0, y: 90.0, width: 659.0, height: 84.0)
    
    
    override func enrichData(validated: [PlainModelProtocol]) -> [PlainModelProtocol]? {
        
   
        for element in validated {
            if let news = element as? News {
                let height = WallCellConfigurator.calcHeaderHeight2(news, frame: postText)
                precalculatedCellHeights.append(height)
            }
        }
        return validated
    }
}


extension NewsPresenter: PaginationPresenterProtocol {
}



extension NewsPresenter: PullWallPresenterProtocol {
    
    func getHeightForCell(indexPath: IndexPath) -> CGFloat {
        guard precalculatedCellHeights.count > indexPath.row else {
            return 0
        }
        return precalculatedCellHeights[indexPath.row]
    }
    
    
    func sendPostText(postText: CGRect) {
        self.postText = postText
    }
    
    
    func selectImage(indexPath: IndexPath, imageIdx: Int) {
        
        guard let news = getData(indexPath: indexPath) as? News
            else {
                Logger.catchError(msg: "NewsPresenter(): PullWallPresenterProtocol(): selectImage: getData exception ")
                return
            }
        
        guard let view = view as? PushWallViewProtocol
                 else {
                     Logger.catchError(msg: "NewsPresenter(): PullWallPresenterProtocol(): selectImage: protocol conform exception")
                     return
                 }
        
        if news.cellType == .video {
            let onSuccess: ((URL, WallCellConstant.VideoPlatform)->Void)? = { (url, platformEnum) in
                view.playVideo(url, platformEnum, indexPath)
            }
            let onError: ((String)->Void)? = {error in
                view.showError(indexPath, err: error)
            }
            SyncMgt.shared.doVideoGet(postId: news.videos[imageIdx].id, ownerId: news.videos[imageIdx].ownerId, onSuccess, onError )
           // SyncMgt.shared.doVideoSearch(q: news.title, completion: completion)
        } else {
            view.runPerformSegue(segueId: "NewsPostSegue", news, selectedImageIdx: imageIdx)
        }
    }
    
    func expandCell(isExpand: Bool, indexPath: IndexPath?) {
        if isExpand, let idx = indexPath {
            expandedIndexesPath.append(idx)
        }
    }
    
    func isExpandedCell(indexPath: IndexPath) -> Bool {
        return expandedIndexesPath.contains(indexPath)
    }
    
    func disableExpanding(indexPath: IndexPath) {
//        if let expandedIdx = expandedIndexPath {
//            if abs(expandedIdx.row - indexPath.row) > 4 {
//                expandedIndexPath = nil
//            }
//        }
    }
}
