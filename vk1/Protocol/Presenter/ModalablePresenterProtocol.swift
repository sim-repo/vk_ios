import Foundation


protocol ModalablePresenterProtocol {
    func willAppearModalView(module: ModuleEnum)
    func didDisappearModalView(module: ModuleEnum)
}
