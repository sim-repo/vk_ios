import Foundation

// view get access to presenter
protocol PullPlainPresenterProtocol: PullPresenterProtocol {

    var numberOfRowsInSection: Int { get }
    func getData(_ indexPath: IndexPath?) -> PlainModelProtocol?
    func viewDidDisappear()
}
