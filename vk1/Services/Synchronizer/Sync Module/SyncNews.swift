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
    
    public func resetOffset(){
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
            syncFromNetwork(presenter, dispatchCompletion)
            return
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
        syncFromNetwork(presenter, dispatchCompletion)
    }
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol,
                                 _ dispatchCompletion: (()->Void)? = nil) {
        
        syncStart = Date()
        
        let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
        
        ApiVK.newsRequest(ownOffset,
                          vkOffset,
                          Network.newsResponseItemsPerRequest,
                          onSuccess,
                          onError,
                          offsetCompletion)
    }
}

