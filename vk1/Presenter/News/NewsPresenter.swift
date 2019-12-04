import Foundation

class NewsPresenter: PlainPresenterProtocols {
    
    var netFinishViewReload: Bool = false
    
    var modelClass: AnyClass  {
        return News.self
    }
}


extension NewsPresenter: PaginationPresenterProtocol {
}



extension NewsPresenter: PullWallPresenterProtocol {
    
    func selectImage(indexPath: IndexPath, imageIdx: Int) {
        
        guard let news = getData(indexPath: indexPath) as? News
            else {
                catchError(msg: "NewsPresenter(): PullWallPresenterProtocol(): selectImage: getData exception ")
                return
            }
        
        guard let view_ = view as? PushWallViewProtocol
                 else {
                     catchError(msg: "NewsPresenter(): PullWallPresenterProtocol(): selectImage: protocol conform exception")
                     return
                 }
        
        if news.cellType == .video {
            let completion: ((URL, WallCellConstant.VideoPlatform)->Void)? = { (url, platformEnum) in
                view_.playVideo(url: url, platformEnum: platformEnum, indexPath: indexPath)
            }
            SyncMgt.shared.doVideoGet(postId: news.videos[imageIdx].id, ownerId: news.videos[imageIdx].ownerId, completion: completion)
           // SyncMgt.shared.doVideoSearch(q: news.title, completion: completion)
        } else {
            view_.runPerformSegue(segueId: "NewsPostSegue", wall: news, selectedImageIdx: imageIdx)
        }
    }
}
