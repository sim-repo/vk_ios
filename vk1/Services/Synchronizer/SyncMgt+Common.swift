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
            SyncWall.shared,
            SyncGroupDetail.shared
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
                
                SyncMyGroupWall.shared.resetOffset()
            case .friend_wall:
                SyncFriendWall.shared.resetOffset()
            default:
                log("viewDidDisappear(): no case \(presenter)", isErr: true)
        }
    }
    
    public func didClearDataSource(moduleEnum: ModuleEnum){
        switch moduleEnum {
            case .friend_wall:
                SyncFriendWall.shared.resetOffset()
            case .news:
                SyncNews.shared.resetOffset()
            default:
                log("clearPresenterData(): no case \(moduleEnum)", isErr: true)
        }
    }
    
    
// MARK: - Called From PresenterFactory:

    public func viewDidLoad(presenterEnum: ModuleEnum){
        sync(presenterEnum)
    }
    
    
    func sync(_ moduleEnum: ModuleEnum){
         switch moduleEnum {
        
         case .friend:
             SyncFriend.shared.sync()
             
         case .friend_wall:
            SyncFriendWall.shared.sync()
             
         case .my_group:
             SyncMyGroup.shared.sync()
             
         case .my_group_detail:
             SyncGroupDetail.shared.sync()
             
         case .my_group_wall:
             SyncMyGroupWall.shared.sync()

         case .news:
            SyncNews.shared.sync()
            
         default:
             catchError(msg: "SynchronizerManager: startSync: no case")
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
                self.log("Sync finished. Sync duration: \(Int(duration)) seconds.", isErr: false)
                
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
            catchError(msg: "\(error.domain)")
        }
        return onError
    }

    func getTryAgainCompletion() -> (()->Void)? {
        return {
            
        }
    }
    
    internal func log(_ msg: String, isErr: Bool) {
        if isErr {
            catchError(msg: "SynchronizerManager(): " + msg)
        } else {
            console(msg: "SynchronizerManager(): " + msg, printEnum: .sync)
        }
    }
}
