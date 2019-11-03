import Foundation

// presenters get access to views
protocol PushPlainViewProtocol : PushViewProtocol {
    func viewReloadData()
}
