import UIKit


// Responsible for making such decisions as:
// 1. what and when will be synchronized
// 2. sync sequences
// 3. decline sync

// well knows about presenters

class SyncMgt {
    
    static let shared = SyncMgt()
    private init() {
        self.synchronizers = [
            SyncWallAdapter.shared,
            SyncGroupDetailAdapter.shared
        ]
    }
    
    private var syncConfiguration = DefaultSyncConfiguration()
    
    private var lastSyncDate: Date? {
        return synchronizers
            .filter{ $0.getLastSyncDate() != nil }
            .sorted{ $0.getLastSyncDate()! > $1.getLastSyncDate()! }
            .first?.getLastSyncDate()
    }
    
    private var syncing: Bool {
        return self.dispatchGroup != nil
    }
    
    private var dispatchGroup: DispatchGroup?
    private var backgroundTaskID: UIBackgroundTaskIdentifier?
    private var synchronizers: [SyncBaseProtocol]!
    
    
// MARK: - called from presenter:
    
    public func doSync(moduleEnum: ModuleEnum){
        sync(moduleEnum)
    }
    
   
    public func viewDidDisappear(presenter: SynchronizedPresenterProtocol){
        let moduleEnum = ModuleEnum(presenter: presenter)
        switch moduleEnum {
            case .my_group_detail:
                //TODO: refactor:
                PresenterFactory.shared.removePresenter(moduleEnum: .my_group_detail)
                PresenterFactory.shared.removePresenter(moduleEnum: .my_group_wall)
                
                SyncMyGroupWallAdapter.shared.resetOffset()
            case .friend_wall:
                SyncFriendWallAdapter.shared.resetOffset()
            default:
                log("viewDidDisappear(): no case \(presenter)", level: .warning)
        }
    }
    
    public func didClearDataSource(moduleEnum: ModuleEnum){
        switch moduleEnum {
            case .friend_wall:
                SyncFriendWallAdapter.shared.resetOffset()
            case .news:
                SyncNewsAdapter.shared.resetOffset()
            default:
                log("didClearDataSource(): no case \(moduleEnum)", level: .warning)
        }
    }
    
    
// MARK: - Called From PresenterFactory:

    public func viewDidLoad(presenterEnum: ModuleEnum){
        sync(presenterEnum)
    }
    
    
    func sync(_ moduleEnum: ModuleEnum){
        
         switch moduleEnum {
            
         case .friend:
             SyncFriendAdapter.shared.sync()
             
         case .friend_wall:
            SyncFriendWallAdapter.shared.sync()
             
         case .my_group:
             SyncMyGroupAdapter.shared.sync()
             
         case .my_group_detail:
             SyncGroupDetailAdapter.shared.sync()
             
         case .my_group_wall:
             SyncMyGroupWallAdapter.shared.sync()

         case .news:
            SyncNewsAdapter.shared.sync()
            
         case .comment:
            SyncCommentAdapter.shared.sync()
            
         case .postLikes:
            PostSyncLikesAdapter.shared.sync()
            
         default:
            log("sync(): no case for \(moduleEnum)", level: .warning)
         }
     }
    
    
    
    


    // MARK: - called by scheduler
    
    
    private func scheduleNextSync() {
        if let lastSyncDate = lastSyncDate {
            let date = lastSyncDate.addingTimeInterval(syncConfiguration.interval)
            let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(startScheduledSync), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    
    @objc func startScheduledSync(applicationCompletion: ((_ newData: Bool) -> Void)? = nil){
        
        var force = false
        if let _lastSyncDate = lastSyncDate {
            // if synced less than an sync interval
            if Date().timeIntervalSince(_lastSyncDate) < syncConfiguration.interval {
                applicationCompletion?(true)
                return
            }
            
            // if tomorrow morning
            if Date().noon != _lastSyncDate.noon && Date.hoursBetween(start: _lastSyncDate, end: Date()) > 6 {
                force = true
            }
        }
        
        
        guard !syncing
        else {
            applicationCompletion?(false)
            return
        }
        
        // if current time is allowed for sync
        let isSyncAllowedTime = Date().isBetween(syncConfiguration.startTime, and: syncConfiguration.endTime)
        
        if !force && !isSyncAllowedTime {
            applicationCompletion?(true)
            return
        }
        
        // Setup background task so syncronization will continue if app goes to background state
        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "com.vk_ios") {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            self.dispatchGroup = nil
        }
        
        // Create synchronization dispatch group
        self.dispatchGroup = DispatchGroup()
        let startSyncTime = Date() // just for debug test
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            // Start every synchronizer
            for synchronizer in self.synchronizers {
                self.dispatchGroup?.enter()
                synchronizer.sync(){ [weak self] in
                    self?.dispatchGroup?.leave()
                }
            }
            
            // Perform when sync will be finished
            self.dispatchGroup?.notify(queue: DispatchQueue.main) {  [weak self] in
                guard let self = self else { return }
                self.dispatchGroup = nil
                
                let duration = Date().timeIntervalSince(startSyncTime)
                self.log("Sync finished. Sync duration: \(Int(duration)) seconds.", level: .info)
                
                self.scheduleNextSync()
                
                // If app in background state then update system that we are done!
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
    
    
 
    

// MARK: - synchronizer's completions
    
    func getFinishNetworkCompletion(_ completion: (()-> Void)? = nil ) -> onNetworkFinish_SyncCompletion {
        let onFinish: onNetworkFinish_SyncCompletion = { synchronizedPresenterProtocol in
            synchronizedPresenterProtocol.didSuccessNetworkFinish()
        }
        return onFinish
    }
    
    
    func getOnErrorCompletion(_ completion: (()-> Void)? = nil ) -> onErrResponse_SyncCompletion {
        let onError: onErrResponse_SyncCompletion = { (error) in
            completion?()
            self.log("\(error.domain)", level: .error)
        }
        return onError
    }

    func getTryAgainCompletion() -> (()->Void)? {
        return {
            
        }
    }
    
    internal func log(_ msg: String, level: Logger.LogLevelEnum) {
        switch level {
            case .info:
                Logger.console(msg: "SynchronizerManager(): " + msg, printEnum: .sync)
            case .warning:
                Logger.catchWarning(msg: "SynchronizerManager(): " + msg)
            case .error:
                Logger.catchError(msg: "SynchronizerManager(): " + msg)
        }
    }
}
