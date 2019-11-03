import Foundation

// synchronizer/factory get access to presenters
protocol SynchronizedPresenterProtocol: class {
    init()
    //failable init
    init?(vc: PushViewProtocol, completion: (()->Void)?)
    func setView(vc: PushViewProtocol, completion: (()->Void)?)
    func dataSourceIsEmpty()->Bool
    func getDataSource() -> [ModelProtocol]
    func clearDataSource()
    func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion?) -> onSuccess_PresenterCompletion
}
