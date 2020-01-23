import Foundation


protocol CoordinatablePresenterProtocol: class {
    func setCoordinator(_ coord: PresentableCoordinatorProtocol)
    func setContext(role: PresenterConstant.ContextRole)
}

protocol CoordinatableIndexingPresenterProtocol: CoordinatablePresenterProtocol {
    func setView(view: PresentableViewProtocol)
}


protocol CoordinatableDetailPresenterProtocol: CoordinatablePresenterProtocol {
    func setMaster(master: ModelProtocol)
}
