import Foundation

protocol PresenterProtocol: class {
    init()
    init(vc: ViewInputProtocol, completion: (()->Void)?) // init from view
    func setView(view: ViewInputProtocol, completion: (()->Void)?)
}
