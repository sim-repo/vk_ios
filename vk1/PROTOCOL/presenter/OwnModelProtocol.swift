import Foundation

// all end-presenters must implement this protocol,
// defines own model for each presenter
protocol OwnModelProtocol {
      var modelClass: AnyClass { get }
}
