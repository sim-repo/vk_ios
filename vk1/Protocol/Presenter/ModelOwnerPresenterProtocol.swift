import Foundation

// presenters have own model
protocol ModelOwnerPresenterProtocol {
    var modelClass: AnyClass { get }
    var netFinishViewReload: Bool { set get }
}
