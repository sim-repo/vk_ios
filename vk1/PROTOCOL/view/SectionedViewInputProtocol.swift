import Foundation

// Protocol for implementation MVP-pattern
protocol SectionedViewInputProtocol : ViewInputProtocol {
    func viewReloadData(groupByIds: [String])
}
