import Foundation

// presenters get access to views
protocol PushViewProtocol: class {
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?)
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?)
}
