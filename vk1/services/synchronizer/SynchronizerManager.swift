import UIKit

class SynchronizerManager {
    
    static let shared = SynchronizerManager()
    private init() {}
    
    public func startSync(){
        console(msg: "SynchronizerManager: startSync..")
        let _: FriendPresenter = PresenterFactory.shared.startPreload() {
            console(msg: "SynchronizerManager: FriendPresenter: sync completed" )
        }
        
        let _: MyGroupPresenter = PresenterFactory.shared.startPreload() {
            console(msg: "SynchronizerManager: GroupPresenter: sync completed" )
        }
    }
}
