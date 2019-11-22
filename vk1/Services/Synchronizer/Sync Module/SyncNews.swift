import UIKit

class SyncNews: SyncBaseProtocol {
    
    static let shared = SyncNews()
    private override init() {}
    
    var vkOffset = "" // returned by vk
    var ownOffset = 0 // generated here
    
    var module: ModuleEnum {
        return ModuleEnum.news
    }
    
    lazy var offsetCompletion: (String) -> Void = {[weak self] offset in
        self?.vkOffset = offset
        self?.incrementOffset()
    }
    
    public func resetOffset() {
        vkOffset = ""
        ownOffset = 0
    }
    
    private func incrementOffset(){
        ownOffset += 1
    }
    
    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        
        guard !syncing else { return }
        
        let presenter = PresenterFactory.shared.getInstance(clazz: NewsPresenter.self)
        
        if force {
            syncing = true
            //cleanup
            syncFromNetwork(presenter, Network.newsResponseItemsPerRequest, dispatchCompletion)
            return
        }
        
        
        
        if ownOffset == 0,
            let lastTimestamp = RealmService.newsLastPostDate(),
            lastTimestamp != 0 {
    
            let interval = Date().timeIntervalSince(getLastSyncDate() ?? Date.yesterday)
                
            if interval > Network.newsMaxIntervalBeforeCleanupDataSource {
                presenter.clearDataSource()
                syncing = true
                syncFromNetwork(presenter, Network.newsResponseItemsPerRequest, dispatchCompletion)
                return
            } else if interval > Network.newsMinIntervalBeforeSendRequest {
                syncing = true
                syncFromNetwork(presenter, 100, dispatchCompletion, Double(lastTimestamp))
                return
            }
        }
        
        //load from disk
        if let news = RealmService.loadNews(filter: "ownOffset = \(ownOffset)"),
            !news.isEmpty {
                vkOffset = news.last?.vkOffset ?? "" //remember for next networking request
                presenter.setFromPersistent(models: news)
                dispatchCompletion?()
                incrementOffset()
            return
        }
        
        //load from network
        syncing = true
        syncFromNetwork(presenter, Network.newsResponseItemsPerRequest, dispatchCompletion)
    }
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol,
                                 _ count: Int,
                                 _ dispatchCompletion: (()->Void)? = nil,
                                 _ sinceTime: Double? = nil
                                 ) {
        
        syncStart = Date()
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
        
        ApiVK.newsRequest(ownOffset,
                          vkOffset,
                          Network.newsResponseItemsPerRequest,
                          onSuccess,
                          onError,
                          offsetCompletion,
                          sinceTime
                          )
    }
}

