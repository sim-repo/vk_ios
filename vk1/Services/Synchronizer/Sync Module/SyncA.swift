import UIKit


class SyncA {
     
    var syncing = false
    var ownOffset = 0
    var serverOffset = ""
    var presenter: SynchronizedPresenterProtocol?
    var tryCount = 0
    
//    lazy var offsetCompletion: (String) -> Void = {[weak self] offset in
//        self?.serverOffset = offset
//        self?.incrementOffset()
//    }
    
    func setup() {
        guard let child = self as? SyncChildProtocol
            else {
                catchError(msg: "SyncA(): setup(): downcasting error")
                return
        }
        presenter = PresenterFactory.shared.getPresenter(moduleEnum: child.module)
    }
    
    func getLastSyncDate() -> Date? {
        guard let child = self as? SyncChild_BkgOffset
            else {
                catchError(msg: "SyncBase(): getLastSyncDate(): SyncBaseProtocol is not implemented")
                return nil
        }
        return UserDefaults.standard.value(forKey: UserDefaultsEnum.lastSyncDate.rawValue + child.module.rawValue) as? Date
    }
    
    
    func setLastSyncDate(date: Date) {
        guard let child = self as? SyncChild_BkgOffset
            else {
                catchError(msg: "SyncBase(): setLastSyncDate(): SyncBaseProtocol is not implemented")
                return
        }
        UserDefaults.standard.setValue(date, forKey: UserDefaultsEnum.lastSyncDate.rawValue + child.module.rawValue)
    }
    
//    private func incrementOffset(){
//        ownOffset += 1
//    }
//
//    func resetOffset() {
//        serverOffset = ""
//        ownOffset = 0
//    }
//
    func getCompletions(presenter: SynchronizedPresenterProtocol, _ dispatchCompletion: (()->Void)? = nil) ->
        (onSuccess_PresenterCompletion, onErrResponse_SyncCompletion) {
            
            let onSuccess_SyncCompletion = SynchronizerManager.shared.getFinishNetworkCompletion()
            
            let onSuccess_PresenterCompletion = presenter.didSuccessNetworkResponse { [weak self] in
                onSuccess_SyncCompletion(presenter)
                dispatchCompletion?()
                self?.setLastSyncDate(date: Date())
                self?.syncing = false
            }
            
            
            let onError_SyncCompletion = SynchronizerManager.shared.getOnErrorCompletion() { [weak self] in
                guard let self = self else { return }
                dispatchCompletion?()
                self.syncing = false
                if self.tryCount < 3 {
                    self.sync(force: true, dispatchCompletion)
                    self.tryCount+=1
                } else {
                    catchError(msg: "SyncBase(): network request")
                    self.tryCount = 0
                    presenter.didErrorNetworkFinish()
                }
            }
            return (onSuccess_PresenterCompletion, onError_SyncCompletion)
    }
    
    
    
    func sync(force: Bool = false, _ dispatchCompletion: (()->Void)? = nil) {
        setup()
        guard let presenter_ = presenter else  { return }
        guard !syncing else { return }
        guard let child = self as? SyncChildProtocol else { return }
        
        
        var ownOffset = 0
        
        switch child {
            case is SyncChild_OwnOffset:
                ownOffset = (child as! SyncChild_OwnOffset).getOwnOffset()
                break
            case is SyncChild_BkgOffset:
                ownOffset = (child as! SyncChild_BkgOffset).getOwnOffset()
                break
            case is SyncChild_OwnOffset_DetailId:
                var ch = child as! SyncChild_OwnOffset_DetailId
                guard let p = presenter_ as? DetailPresenterProtocol else { catchError(msg: "SyncFriendWall: sync(): presenter is not conformed DetailPresenterProtocol"); return }
                guard let id = p.getId() else { catchError(msg: "SyncFriendWall: sync(): no id"); return }
                ownOffset = ch.getOwnOffset(id: id)
                ch.id = id
                break
            case is SyncChild_BkgOffset_DetailId:
                var ch = child as! SyncChild_BkgOffset_DetailId
                guard let p = presenter_ as? DetailPresenterProtocol else { catchError(msg: "SyncFriendWall: sync(): presenter is not conformed DetailPresenterProtocol"); return }
                guard let id = p.getId() else { catchError(msg: "SyncFriendWall: sync(): no id"); return }
                ownOffset = (child as! SyncChild_BkgOffset_DetailId).getOwnOffset(id: id)
                ch.id = id
                break
            default:
                break
        }
        
        
        if ownOffset == 0,
            let lastTimestamp = child.getLastPostDate(),
            lastTimestamp != 0 {
            
            let interval = Date().timeIntervalSince(getLastSyncDate() ?? Date.yesterday)
            
            if interval > Network.maxIntervalBeforeCleanupDataSource {
                presenter_.clearDataSource()
                syncing = true
                syncFromNetwork(presenter_, count: Network.newsResponseItemsPerRequest, dispatchCompletion)
                return
            } else if interval > Network.minIntervalBeforeSendRequest {
                syncing = true
                syncFromNetwork(presenter_, count: 100, sinceTime: Double(lastTimestamp), dispatchCompletion)
                return
            }
        }
        
        
        if let models = child.loadModelFromRealm(ownOffset: ownOffset),
            !models.isEmpty {
            
            if let arr = models as? [DecodableModelServerOffsetProtocol] {
                serverOffset = arr.last?.getServerOffset() ?? ""
            }
            presenter_.setFromPersistent(models: models)
            dispatchCompletion?()
            child.incrementOffset()
            return
        }
        
        //load from network
        syncing = true
        syncFromNetwork(presenter_, count: Network.newsResponseItemsPerRequest, dispatchCompletion)
    }
    
    
    private func syncFromNetwork(id: typeId? = nil,
                                 _ presenter: SynchronizedPresenterProtocol,
                                 count: Int,
                                 sinceTime: Double? = nil,
                                 _ dispatchCompletion: (()->Void)? = nil) {
        
        guard let child = self as? SyncChildProtocol else { return }
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
        
         switch child {
                   case is SyncChild_OwnOffset:
                    let ch = child as! SyncChild_OwnOffset
                    let offsetCompletion = ch.getOffsetCompletion()
                    ch.apiRequest(ownOffset,
                                   Network.newsResponseItemsPerRequest,
                                   onSuccess,
                                   onError,
                                   offsetCompletion,
                                   sinceTime)
                   break
            
                   case is SyncChild_BkgOffset:
                        let ch = child as! SyncChild_BkgOffset
                        let offsetCompletion = ch.getOffsetCompletion()
                        ch.apiRequest(ownOffset,
                                      ch.serverOffset,
                                      Network.newsResponseItemsPerRequest,
                                      onSuccess,
                                      onError,
                                      offsetCompletion,
                                      sinceTime)
                       break
            
                   case is SyncChild_OwnOffset_DetailId:
                      let ch = child as! SyncChild_OwnOffset_DetailId
                      let offsetCompletion = ch.getOffsetCompletion(id: ch.id)
                      ch.apiRequest(ownOffset,
                                    Network.newsResponseItemsPerRequest,
                                    onSuccess,
                                    onError,
                                    offsetCompletion,
                                    sinceTime)
                       break
                   
         
                    case is SyncChild_BkgOffset_DetailId:
                       let ch = child as! SyncChild_BkgOffset_DetailId
                       let offsetCompletion = ch.getOffsetCompletion(id: ch.id)
                       ch.apiRequest(ownOffset,
                                     ch.serverOffset,
                                     Network.newsResponseItemsPerRequest,
                                     onSuccess,
                                     onError,
                                     offsetCompletion,
                                     sinceTime)
                        break
                   
         
                default: break
        }
    }
}


