import Foundation

// presenters get access to views
protocol PushViewProtocol: class {
    
    func startWaitIndicator(_ moduleEnum: ModuleEnum?)
    func stopWaitIndicator(_ moduleEnum: ModuleEnum?)
}


protocol PushSectionedViewProtocol : PushViewProtocol {
    func viewReloadData(groupByIds: [String])
}


protocol PushPlainViewProtocol : PushViewProtocol {
    func viewReloadData(moduleEnum: ModuleEnum)
    func insertItems(startIdx: Int, endIdx: Int)
}


//MARK: - Specific Protocols

protocol PushLoginViewProtocol {
    func showVkAuthentication(completion: (()->Void)?)
    func showFibAuthentication(login: String, psw: String, completion: (()->Void)?)
}
