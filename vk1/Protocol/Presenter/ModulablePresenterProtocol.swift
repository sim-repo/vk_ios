import Foundation


protocol ModulablePresenterProtocol {
    var module: ModuleEnum { get set }
    var modelClass: ModelProtocol.Type { get }
}
