import Foundation
import Alamofire


//lesson 3: Operation Queue
class OperationCaller {
    
    static var shared = OperationCaller()
    let serialQueue = OperationQueue()

    private init(){
        serialQueue.maxConcurrentOperationCount = 1
        serialQueue.qualityOfService = .userInitiated
    }
    
    
    func newsOperationRequest(  currTry: Int = 0,
                                _ urlPath: String,
                                _ params: Parameters,
                                _ ownOffset: Int,
                                _ vkOffset: String,
                                _ onSuccess: @escaping onSuccess_PresenterCompletion,
                                _ onError: @escaping  onErrResponse_SyncCompletion,
                                _ offsetCompletion: ((String)->Void)?) {
        
        let newsOperation = NewsNetworkOperationService()
        print("TRYING \(currTry)")
        newsOperation.setup(currTry: currTry,
                             urlPath,
                             params,
                             ownOffset,
                             vkOffset,
                             onSuccess,
                             onError,
                             offsetCompletion)
        
        newsOperation.completionBlock = {
            if let _ = newsOperation.outputError {
                if newsOperation.outputIsMaxAttemptsExceeded {
                    return
                }
                let currTry = newsOperation.getCurrTry()
                OperationCaller.shared.newsOperationRequest(currTry: currTry, urlPath, params, ownOffset, vkOffset, onSuccess, onError, offsetCompletion)
            }
        }
        
        serialQueue.addOperation(newsOperation)
    }
}
