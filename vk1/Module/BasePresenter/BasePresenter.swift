import Foundation


public class BasePresenter: CoordinatablePresenterProtocol {
    
    var contextRole: PresenterConstant.ContextRole = .master {
        didSet {
            didSetContext()
        }
    }
    
    func setContext(role: PresenterConstant.ContextRole) {
        contextRole = role
    }
    
    func didSetContext() {
        fatalError("BasePresenter: didSetContext(): this method must be overrided")
    }
}
