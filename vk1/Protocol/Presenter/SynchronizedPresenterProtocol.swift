import Foundation

// synchronizer/factory get access to presenters
protocol SynchronizedPresenterProtocol: class {
    init()
    //failable init
    init?(vc: PushViewProtocol)
    func setView(vc: PushViewProtocol)
    func dataSourceIsEmpty()->Bool
    func getDataSource() -> [ModelProtocol]
    func clearDataSource()
    func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion?) -> onSuccess_PresenterCompletion
    func didSuccessNetworkFinish()
    func setFromPersistent(models: [DecodableProtocol])
    func setSyncProgress(curr: Int, sum: Int)
}
