import UIKit


// Class-Factory for creating and storing presenters
class PresenterFactory {
    
    static let shared = PresenterFactory()
    private init(){}

    // store
    private lazy var view2Presenter: [String:PresenterProtocol] = [:]
    private lazy var presenters: [String:AnyObject] = [:]
    
    // MARK: public methods
    
    // called from VCs >>
    public func getSectioned(vc: ViewProtocol, _ completion: (()->Void)? = nil) -> SectionedPresenterProtocol? {
        return getFromFactory(vc) as? SectionedPresenterProtocol
    }
    
    public func getPlain(vc: ViewProtocol, _ completion: (()->Void)? = nil) -> PlainPresenterProtocol? {
        return getFromFactory(vc) as? PlainPresenterProtocol
    }
    
    
    // called when needs for preloading >>
    public func startPreload<T: PresenterProtocol>(_ completion: (()->Void)? = nil) -> T {
        let presenter: T = T(beginLoadFrom: .networkFirst, completion: completion)
        let clazz = String(describing: T.self)
        presenters[clazz] = presenter
        if let nameVC = getViewCode(presenter) {
            view2Presenter[nameVC] = presenter
        }
        return presenter
    }
    
    
    // MARK: private methods
    
    private func getFromFactory(_ vc: ViewProtocol, _ completion: (()->Void)? = nil) -> PresenterProtocol? {
        switch vc {
                   case is Friend_Controller :
                        let p: FriendPresenter? = getPresenter(vc: vc, completion)
                        return p
                   case is MyGroups_ViewController :
                        let p: MyGroupPresenter? = getPresenter(vc: vc, completion)
                        return p
                   case is Group_ViewController:
                        let p: GroupPresenter? = getPresenter(vc: vc, completion)
                        return p
                   case is Wall_Controller:
                        let p: WallPresenter? = getPresenter(vc: vc, completion)
                        return p
                   default:
                        catchError(msg: "PresenterFactory: getFromFactory: no presenter for \(vc)")
        }
        return nil
    }
    
    
    private func getPresenter<T: PresenterProtocol>(vc: ViewProtocol, _ completion: (()->Void)? = nil) -> T? {
        let clazz = vc.className()
        var res: T? = view2Presenter[clazz] as? T
        
        if res == nil {
            res = createPresenter(vc, completion)
        } else {
            res?.setView(view: vc, completion: completion)
        }
        return res
    }
    
    
    private func createPresenter<T: PresenterProtocol>(_ vc: ViewProtocol, _ completion: (()->Void)? = nil) -> T? {
        let presenter: T = T(vc: vc, beginLoadFrom: .networkFirst, completion: completion)
        let clazz = vc.className()
        view2Presenter[clazz] = presenter
        presenters[clazz] = presenter
        return presenter
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
}
