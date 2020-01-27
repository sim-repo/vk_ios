import Foundation
import Alamofire

//lesson 3: Operation Queue
public class NewsNetworkOperationService : AsyncOperaton {
    
    private var urlPath: String!
    private var params: Parameters!
    private var ownOffset: Int!
    private var vkOffset: String!
    private var onSuccess: onSuccess_PresenterCompletion!
    private var onError: onErrResponse_SyncCompletion!
    private var offsetCompletion: ((String)->Void)?
    private var maxTry = 4
    
    private var outputArr:[News]?
    private var currTry = 0
    public var outputError: NSError?
    public var outputIsMaxAttemptsExceeded = false
    
    func setup(currTry: Int,
               _ URLpath: String,
               _ params: Parameters,
               _ ownOffset: Int,
               _ vkOffset: String,
               _ onSuccess: @escaping onSuccess_PresenterCompletion,
               _ onError: @escaping  onErrResponse_SyncCompletion,
               _ offsetCompletion: ((String)->Void)?) {
        
        self.currTry = currTry
        self.urlPath = URLpath
        self.params = params
        self.ownOffset = ownOffset
        self.vkOffset = vkOffset
        self.onSuccess = onSuccess
        self.onError = onError
        self.offsetCompletion = offsetCompletion
    }
    
    func getCurrTry() -> Int {
        currTry
    }
    
    func getOutputArr() -> [News]? {
        outputArr
    }
    
    
    private func isMaxAttemptsExceeded() -> Bool {
        outputIsMaxAttemptsExceeded = currTry >= maxTry
        return outputIsMaxAttemptsExceeded
    }
    
    private func finish() {
        self.state = .finished
    }
    
    public override func main() {
        
        guard !isMaxAttemptsExceeded()
            else {
                finish()
                return
        }
        
        currTry += 1
        
        AlamofireService.sharedManager.request(NetworkConstant.shared.baseURL + urlPath, method: .get, parameters: params).responseJSON{ [weak self] response in
            guard let self = self else { return }
            
            
            #if DEBUG
            if self.currTry == 1 {
                let err = NSError(domain: "AlamofireService: newsRequest(): response data is null", code: 123, userInfo: nil)
                self.outputError = err
                self.finish()
                return
            }
            #endif
            
            switch response.result {
            case .success(let json):
                self.outputArr = NewsParser.parseJson(json, self.ownOffset, self.vkOffset)
                
                if let arr = self.outputArr {
                    if arr.isEmpty {
                        let err = NSError(domain: "AlamofireService: newsRequest(): response data is null", code: 123, userInfo: nil)
                        self.outputError = err
                        if self.isMaxAttemptsExceeded() {
                            self.onError(err)
                        }
                    } else {
                        if let offset = NewsParser.parseNextOffset(json) {
                            self.offsetCompletion?(offset)
                        }
                        self.onSuccess(arr)
                        
                    }
                }
            case .failure(let err as NSError):
                self.outputError = err
                if self.isMaxAttemptsExceeded() {
                    self.onError(err)
                }
                
            }
            self.finish()
        }
    }
}
