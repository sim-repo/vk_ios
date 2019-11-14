import Foundation


// for detail presenters which getting model throw segue
protocol DetailPresenterProtocol {
    var detailModel: ModelProtocol? { get set }
    func getId() -> typeId?
    func setDetailModel(model: ModelProtocol)
}
