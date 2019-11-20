import Foundation

// presenters get access to views
protocol PushPlainViewProtocol : PushViewProtocol {
    func viewReloadData(moduleEnum: ModuleEnum)
    func insertItems(startIdx: Int, endIdx: Int)
}
