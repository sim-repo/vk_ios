import Foundation


protocol DetailablePresenterProtocol {
    func didSetMaster(master: ModelProtocol)
    func enrichData(datasource: [ModelProtocol])
}
