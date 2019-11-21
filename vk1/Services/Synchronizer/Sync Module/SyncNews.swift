import UIKit

class SyncNews: SyncBaseProtocol {
    
    static let shared = SyncNews()
    private override init() {}
    
    var offset = ""
    
    let queue = DispatchQueue.global(qos: .background)
    
    var module: ModuleEnum {
        return ModuleEnum.news
    }
    
    lazy var setNextOffsetCompletion: (String) -> Void = {[weak self] offset1 in
        self?.offset = offset1
    }
    
    func sync(force: Bool = false,
              _ dispatchCompletion: (()->Void)? = nil) {
        guard !syncing else { return }
        
        queue.sync {
            let presenter = PresenterFactory.shared.getInstance(clazz: NewsPresenter.self)
            
            if force {
                syncing = true
                syncFromNetwork(presenter, dispatchCompletion)
                return
            }
        }
    }
    
    
    private func syncFromNetwork(_ presenter: SynchronizedPresenterProtocol,
                                 _ dispatchCompletion: (()->Void)? = nil) {
         
         // clear all
         syncStart = Date()
        
         let (onSuccess, onError) = getCompletions(presenter: presenter, dispatchCompletion)
         
        ApiVK.newsRequest(offset,
                          Network.newsResponseItemsPerRequest,
                          onSuccess: onSuccess,
                          onError: onError,
                          setNextOffsetCompletion: setNextOffsetCompletion)
     }
}

