import UIKit


// Class-Factory for creating and storing presenters
class PresenterFactory {
    
    static let shared = PresenterFactory()
    private init(){}

    // store
    private lazy var view2Presenter: [String:PresenterProtocol] = [:]
    private lazy var presenters: [String:PresenterProtocol] = [:]
    
    
    
    //MARK: called from Synchronizer >>
    
    public func getInstance<T: PresenterProtocol>() -> T {
        if let presenter: T = getPresenter() {
            return presenter
        }
        
        let presenter: T = T()
        let clazz = String(describing: T.self)
        presenters[clazz] = presenter
        if let nameVC = getViewCode(presenter) {
            view2Presenter[nameVC] = presenter
        }
        return presenter
    }
    
    public func getPresenter<T: PresenterProtocol>() -> T? {
        let clazz = String(describing: T.self)
        let res: T? = presenters[clazz] as? T
        return res
    }
    
    private func getViewCode<T:PresenterProtocol>(_ presenter: T) -> String? {
        switch presenter {
        case is FriendPresenter:
            return String(describing: Friend_Controller.self)
        case is MyGroupPresenter:
            return String(describing: MyGroups_ViewController.self)
        case is GroupPresenter:
            return String(describing: Group_ViewController.self)
        case is WallPresenter:
            return String(describing: Wall_Controller.self)
        default:
            catchError(msg: "PresenterFactory: getViewCode: no vc for \(String(describing: presenter))")
        }
        return nil
    }
    
    
    
    
    //MARK: called from VCs >>
    
    public func getSectioned(vc: ViewInputProtocol, _ completion: (()->Void)? = nil) -> SectionedPresenterProtocol? {
        return getFromFactory(vc) as? SectionedPresenterProtocol
    }
    
    public func getPlain(vc: ViewInputProtocol, _ completion: (()->Void)? = nil) -> PlainPresenterProtocol? {
        return getFromFactory(vc) as? PlainPresenterProtocol
    }
    
    
    // private methods
    
    private func getFromFactory(_ vc: ViewInputProtocol, _ completion: (()->Void)? = nil) -> PresenterProtocol? {
        var res: PresenterProtocol?
        switch vc {
                   case is Friend_Controller :
                        let p: FriendPresenter? = getPresenter(vc: vc, completion)
                        res = p
                   case is MyGroups_ViewController :
                        let p: MyGroupPresenter? = getPresenter(vc: vc, completion)
                        res = p
                   case is Group_ViewController:
                        let p: GroupPresenter? = getPresenter(vc: vc, completion)
                        res = p
                   case is Wall_Controller:
                        let p: WallPresenter? = getPresenter(vc: vc, completion)
                        res = p
                   default:
                        catchError(msg: "PresenterFactory: getFromFactory: no presenter for \(vc)")
        }
        SynchronizerManager.shared.presenterSetup(presenter: res)
        return res
    }
    
    
    private func getPresenter<T: PresenterProtocol>(vc: ViewInputProtocol, _ completion: (()->Void)? = nil) -> T? {
        let clazz = vc.className()
        var res: T? = view2Presenter[clazz] as? T
        
        if res == nil {
            res = createPresenter(vc, completion)
        } else {
            res?.setView(view: vc, completion: completion)
        }
        return res
    }
    
    
    private func createPresenter<T: PresenterProtocol>(_ vc: ViewInputProtocol, _ completion: (()->Void)? = nil) -> T? {
        let presenter: T = T(vc: vc, completion: completion)
        let nameVC = vc.className()
        view2Presenter[nameVC] = presenter
        let clazz = String(describing: T.self)
        presenters[clazz] = presenter
        return presenter
    }
  
}
