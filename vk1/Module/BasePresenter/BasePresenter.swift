import Foundation


public class BasePresenter: CoordinatablePresenterProtocol {
    
    var coordinator: PresentableCoordinatorProtocol?
    
    var contextRole: PresenterConstant.ContextRole = .master {
        didSet {
            didSetContext()
        }
    }
    
    func setContext(role: PresenterConstant.ContextRole) {
        contextRole = role
    }
    
    func setCoordinator(_ coord: PresentableCoordinatorProtocol) {
        self.coordinator = coord
    }
    
    
    func didSetContext() {
        fatalError("BasePresenter: didSetContext(): this method must be overrided")
    }
}
