import Foundation


// for detailed presenters
protocol DetailPresenterProtocol {
    var parentModel: ModelProtocol? { get set }
    func getId() -> typeId?
    func setParentModel(model: ModelProtocol)
}
