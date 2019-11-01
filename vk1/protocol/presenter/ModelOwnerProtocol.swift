import Foundation

// all end-presenters must implement this
// defines model for each presenter
protocol ModelOwnerProtocol {
      var modelClass: AnyClass { get }
}
