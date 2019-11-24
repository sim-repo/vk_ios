import Foundation

// presenters have own model
protocol ModelOwnerPresenterProtocol {
    var modelClass: AnyClass { get }
    var netFinishViewReload: Bool { set get }
}


// defines model class + base for section presenters
typealias SectionPresenterProtocols = SectionedBasePresenter & ModelOwnerPresenterProtocol


// defines model class + base for plain presenters
typealias PlainPresenterProtocols = PlainBasePresenter & ModelOwnerPresenterProtocol
