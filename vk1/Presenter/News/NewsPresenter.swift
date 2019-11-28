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
        
       // let url = wall.getImageURLs()[imageIdx]
     
        guard let view_ = view as? PushWallViewProtocol
            else {
                catchError(msg: "NewsPresenter(): PullWallPresenterProtocol(): selectImage: protocol conform exception")
                return
            }
        view_.runPerformSegue(segueId: "NewsPostSegue", wall: news, selectedImageIdx: imageIdx)
    }
}
