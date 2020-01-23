import Foundation

protocol PresentableCoordinatorProtocol {
    func didPressTransition(to module: ModuleEnum, model: ModelProtocol)
    func didPressBack()
}
