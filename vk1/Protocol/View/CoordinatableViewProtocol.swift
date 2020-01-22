import Foundation

protocol CoordinatableViewProtocol: class {
    func setPresenter(_ presenter: ViewablePresenterProtocol)
}


protocol CoordinatableSegueViewProtocol : CoordinatableViewProtocol {
    func runSegue(module: ModuleEnum)
}


//MARK: - Specific Protocols


//Login
protocol CoordinatableLoginViewProtocol : CoordinatableViewProtocol {
    func runSegue()
}


