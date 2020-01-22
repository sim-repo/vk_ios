import Foundation


protocol CoordinatablePresenterProtocol: class {
    func setContext(role: PresenterConstant.ContextRole)
}

protocol CoordinatableIndexingPresenterProtocol: CoordinatablePresenterProtocol {
    func setView(view: PresentableViewProtocol)
}
