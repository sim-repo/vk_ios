import UIKit


// Responsible for making such decisions as:
// 1. what and when will be synchronized
// 2. sync sequences
// 3. decline sync

// well knows about presenters

class SynchronizerManager {
    
    static let shared = SynchronizerManager()
    private init() {}
    
    
    // called from Presenter
    public func callSyncFromPresenter(moduleEnum: ModuleEnum){
        startSync(moduleEnum)
    }
    
    // called from Presenter
    public func viewDidDisappear(presenter: SynchronizedPresenterProtocol){
        let moduleEnum = ModuleEnum(presenter: presenter)
        switch moduleEnum {
            case .my_group_detail:
                PresenterFactory.shared.removePresenter(moduleEnum: moduleEnum)
                let groupWall: ModuleEnum = .my_group_wall
                PresenterFactory.shared.removePresenter(moduleEnum: groupWall)
            default:
                console(msg: "SynchronizerManager: viewDidDisappear: no case \(presenter)")
        }
    }
    
    // called from PresenterFactory
    public func viewDidLoad(presenterEnum: ModuleEnum){
        startSync(presenterEnum)
    }
    
    
    func startSync(_ presenterEnum: ModuleEnum){
        switch presenterEnum {
            
        case .friend:
            let p = PresenterFactory.shared.getInstance(clazz: FriendPresenter.self)
            if p.dataSourceIsEmpty() {
                SyncFriend.shared.sync(p)
            }
            
            //        case .detail_friend:
            //            let p = PresenterFactory.shared.getInstance(clazz: DetailFriendPresenter.self)
            //            if p.dataSourceIsEmpty() {
            //                SyncDetailFriend.shared.sync(p)
            //            }
        //
        case .my_group:
            let p = PresenterFactory.shared.getInstance(clazz: MyGroupPresenter.self)
            if p.dataSourceIsEmpty() {
                SyncMyGroup.shared.sync(p)
            }
            
        case .my_group_detail:
            let p = PresenterFactory.shared.getInstance(clazz: MyGroupDetailPresenter.self)
            if p.dataSourceIsEmpty() {
                SyncGroupDetail.shared.sync(p)
            }
            
        case .my_group_wall:
            let p = PresenterFactory.shared.getInstance(clazz: MyGroupWallPresenter.self)
            if p.dataSourceIsEmpty() {
                SyncMyGroupWall.shared.sync(p)
            }
            
        case .group:
            let p = PresenterFactory.shared.getInstance(clazz: GroupPresenter.self)
            if p.dataSourceIsEmpty() {
                SyncGroup.shared.sync(p)
            }
            
        case .wall:
            let p = PresenterFactory.shared.getInstance(clazz: WallPresenter.self)
            if p.dataSourceIsEmpty() {
                SyncWall.shared.sync(force: false)
            }
            
        case .friend_wall:
            let p = PresenterFactory.shared.getInstance(clazz: FriendWallPresenter.self)
            if p.dataSourceIsEmpty() {
                SyncFriendWall.shared.sync(p)
            }
            
        case .profile:
            let p = PresenterFactory.shared.getInstance(clazz: ProfilePresenter.self)
            SyncProfile.shared.sync(p)
            
        case .login:
            SyncLogin.shared.sync(force: true)
            
        case .unknown:
            catchError(msg: "SynchronizerManager: startSync: no case")
        }
        
    }
    
    func getFinishNetworkCompletion(_ completion: (()-> Void)? = nil ) -> onNetworkFinish_SyncCompletion {
        let onFinish: onNetworkFinish_SyncCompletion = { synchronizedPresenterProtocol in
            synchronizedPresenterProtocol.didSuccessNetworkFinish()
        }
        return onFinish
    }
    
    
    func getOnErrorCompletion(_ completion: (()-> Void)? = nil ) -> onErrResponse_SyncCompletion {
        let onError: onErrResponse_SyncCompletion = { (error) in
            completion?()
            catchError(msg: "\(error.domain)")
        }
        return onError
    }
    
}
