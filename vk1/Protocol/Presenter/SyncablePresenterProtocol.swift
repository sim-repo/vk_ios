import Foundation

// synchronizer get access to presenters
protocol SyncablePresenterProtocol: class {
    func didSuccessNetworkResponse(completion: onSuccessResponse_SyncCompletion?) -> onSuccess_PresenterCompletion
    func didSuccessNetworkFinish()
    func didErrorNetworkFinish()
    
    func setFromPersistent(models: [ModelProtocol])
    func clearDataSource(id: Int?)
}

protocol SyncablePresenterParametersProtocol {
    var isViewReloadWhenNetFinish: Bool { get set }
}

//MARK: - Specific Protocols

protocol SyncableCommentPresenterProtocol: class {
    func getNews() -> News
}


protocol SyncablePostLikesPresenterProtocol: class {
    func getComment() -> Comment
}


protocol SyncableMyGroupWallPresenterProtocol: class {
    func getMyGroup() -> MyGroup
}


protocol SyncableFriendWallPresenterProtocol: class {
    func getOwnerId() -> Int
}
