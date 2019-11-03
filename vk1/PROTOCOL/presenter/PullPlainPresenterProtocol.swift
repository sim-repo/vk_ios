import Foundation

// view get access to presenter
protocol PullPlainPresenterProtocol: PullPresenterProtocol {

    func numberOfRowsInSection() -> Int
    func viewDidDisappear()
}
