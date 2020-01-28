import UIKit

class FriendPresenter: SectionPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    
    var modelClass: AnyClass  {
        return Friend.self
    }
}


extension FriendPresenter: PullWallPresenterProtocol {
    
    func selectImage(indexPath: IndexPath, imageIdx: Int) {
        let wall = getData(indexPath: indexPath) as? Wall
        let url = wall?.getImageURLs()[imageIdx]
    }
    
    func expandCell(isExpand: Bool, indexPath: IndexPath?) {
    }
    
    func isExpandedCell(indexPath: IndexPath) -> Bool {
        return false
    }
    
    func didPressLike(indexPath: IndexPath) {
        // TODO
    }
    
    func didPressComment(indexPath: IndexPath) {
        // TODO
    }
    
    func didPressShare(indexPath: IndexPath) {
        // TODO
    }
    
}

//lesson 5: Cache
extension FriendPresenter: ImageablePresenterProtocol {
    
    func tryImageLoad(indexPath: IndexPath, url: URL){
        PhotoService.shared.loadImage(presenter: self, indexPath: indexPath, url: url)
    }
    
    func didImageLoad(indexPath: IndexPath, image: UIImage) {
        
        if let friend = getData(indexPath: indexPath) as? Friend {
            friend.setImages(avaImage200: image)
            view?.viewReloadImage(indexPath: indexPath)
        }
    }
    
    func didReceiveMemoryWarning() {
        PhotoService.shared.clear()
    }
}
