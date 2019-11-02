import UIKit


// Responsible for making such decisions as:
// 1. what and when will be synchronized
// 2. sync sequences
// 3. decline sync

// well knows about presenters

class SynchronizerManager {
    
    static let shared = SynchronizerManager()
    private init() {}
    
    // called from PresenterFactory
    public func viewDidLoad(presenterEnum: ModuleEnum, _ completion: (()->Void)? = nil){
        
        switch presenterEnum {
        
        case .friend:
            let p: FriendPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncFriend.shared.sync(p, completion)
            }
            
        case .detail_friend:
            let p: DetailFriendPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncDetailFriend.shared.sync(p, completion)
            }
            
        case .my_group:
            let p: MyGroupPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncMyGroup.shared.sync(p, completion)
            }
            
        case .my_group_detail:
            let p: MyGroupDetailPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncGroupDetail.shared.sync(p, completion)
            }
            
        case .group:
            let p: GroupPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncGroup.shared.sync(p, completion)
            }
        
        case .wall:
            let p: WallPresenter = PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncWall.shared.sync(force: false)
            }

        case .friend_wall:
            let p: FriendWallPresenter =  PresenterFactory.shared.getInstance()
            if p.dataSourceIsEmpty() {
                SyncFriendWall.shared.sync(p, completion)
            }
            
        case .profile:
            let p: ProfilePresenter = PresenterFactory.shared.getInstance()
            SyncProfile.shared.sync(p, completion)
            
        case .login:
            SyncLogin.shared.sync(force: true)
        }
    }
    
    
    func getOnErrorCompletion(_ completion: (()-> Void)? = nil ) -> onErrSyncCompletion {
        let onError: onErrSyncCompletion = { (error) in
            completion?()
            catchError(msg: "\(error.domain)")
        }
        return onError
    }
        
}
