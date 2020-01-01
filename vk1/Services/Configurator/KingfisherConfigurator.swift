import Foundation
import Kingfisher


class KingfisherConfigurator {
     
    static func setup(){
        let cache = KingfisherManager.shared.cache
        cache.memoryStorage.config.totalCostLimit = 1 * 1024 * 1024
        cache.diskStorage.config.sizeLimit = 100 * 1024 * 1024
        cache.maxCachePeriodInSecond = 200 * 60 * 24 * 3
        
        // Memory image expires after 10 minutes.
        cache.memoryStorage.config.expiration = .seconds(10)
        // Disk image never expires.
        cache.diskStorage.config.expiration = .never
        
        // Check memory clean up every 30 seconds.
       // cache.memoryStorage.config.cleanInterval = 30
    }

    static func clearCache(){
        let cache = KingfisherManager.shared.cache
        cache.clearMemoryCache()
    }
}
