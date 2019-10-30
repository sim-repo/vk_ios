import Foundation

// Protocol for implementation MVP-pattern
protocol ViewInputProtocol : ViewProtocol {
    func refreshDataSource()
    func optimReloadCell(indexPath: IndexPath)
}
