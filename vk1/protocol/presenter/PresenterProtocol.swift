import Foundation

protocol PresenterProtocol: class {
    
    init(vc: ViewProtocol, beginLoadFrom: LoadModelType, completion: (()->Void)?) // init from view
    init(beginLoadFrom: LoadModelType, completion: (()->Void)?) // view is not exists
    func setView(view: ViewProtocol, completion: (()->Void)?)
}
