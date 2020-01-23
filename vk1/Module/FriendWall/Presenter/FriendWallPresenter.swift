import Foundation

class FriendWallPresenter : PlainBasePresenter, ModulablePresenterProtocol, SyncablePresenterParametersProtocol {
    
    var isViewReloadWhenNetFinish = false

    var module: ModuleEnum = .friendWall
    
    var modelClass: ModelProtocol.Type  {
        return Wall.self
    }
    
    // needed for network api request:
    var friend: Friend?
    var ownerId = 0
    
    var expandedIndexPath: IndexPath?
    
    override func didSetContext() {
        synchronizer?.tryRunSync()
    }
    
    private func log(_ msg: String, level: Logger.LogLevelEnum) {
        Logger.log(clazz: "FriendWallPresenter: \(self.clazz): ", msg, level: level, printEnum: .presenter)
    }
}

extension FriendWallPresenter: PaginablePresenterProtocol {}


extension FriendWallPresenter: EnrichablePresenterProtocol {
    
    func enrichData(datasource: [ModelProtocol]) {}
    
    func setMaster(master: ModelProtocol) {
        if let friend = master as? Friend {
            self.friend = friend
            ownerId = friend.id
        }
        if let wall = master as? Wall {
            ownerId = wall.authorId
        }
    }
}


extension FriendWallPresenter: ViewableWallPresenterProtocol {
    
    func didPressAuthor(indexPath: IndexPath) {
        guard let wall = getData(indexPath: indexPath) as? Wall
           else {
               Logger.catchError(msg: "FriendWallPresenter: didPressAuthor(): getData exception")
               return
           }
        if wall.authorId != wall.ownerId {
            coordinator?.didPressTransition(to: .friendWall, model: wall)
        }
    }
    
    func didPressLike(indexPath: IndexPath) {
        // TODO: must implemented
    }
    
    func didPressComment(indexPath: IndexPath) {
        // TODO: must implemented
    }
    
    func didPressShare(indexPath: IndexPath) {
        // TODO: must implemented
    }
    
    func didSelectImage(indexPath: IndexPath, imageIdx: Int) {
        // TODO: must implemented
    }

    func didPressExpandCell(isExpand: Bool, indexPath: IndexPath?) {
        expandedIndexPath = isExpand ? indexPath : nil
    }
    
    func isExpandedCell(indexPath: IndexPath) -> Bool {
        return expandedIndexPath == indexPath
    }
}



extension FriendWallPresenter: SyncableFriendWallPresenterProtocol {
    func getOwnerId() -> Int {
        ownerId
    }
}
