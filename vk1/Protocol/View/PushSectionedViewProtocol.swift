import Foundation

// presenters get access to views
protocol PushSectionedViewProtocol : PushViewProtocol {
    func viewReloadData(groupByIds: [String])
}
