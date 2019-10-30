import Foundation

protocol BasicNetworkProtocol: class {
    func loadFromNetwork(completion: (()->Void)?)
    func datasourceIsEmpty()->Bool
}
