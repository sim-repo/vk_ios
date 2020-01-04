import UIKit

class FriendPresenter: SectionPresenterProtocols {
    
    var netFinishViewReload: Bool = true
    
    
    var modelClass: AnyClass  {
        return Friend.self
    }
}


extension FriendPresenter: PullWallPresenterProtocol {
    
    
    func getHeightForCell(indexPath: IndexPath) -> CGFloat {
        //TODO
        return 0
    }
    
    
    func sendPostText(postText: CGRect) {
        //TODO
    }
    
    
    func selectImage(indexPath: IndexPath, imageIdx: Int) {
        let wall = getData(indexPath: indexPath) as? Wall
        let url = wall?.getImageURLs()[imageIdx]
    }
    
    func expandCell(isExpand: Bool, indexPath: IndexPath?) {
    }
    
    func isExpandedCell(indexPath: IndexPath) -> Bool {
        return false
    }
    
    func disableExpanding(indexPath: IndexPath) {
        
    }
}
