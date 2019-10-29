import UIKit



class PresenterFactory {
    static let shared = PresenterFactory()
    private init(){}

    private lazy var view2Presenter: [String:PresenterProtocol] = [:]
    private lazy var presenters: [String:AnyObject] = [:]
    
    
    public func getSectioned(vc: ViewProtocolDelegate, _ completion: (()->Void)? = nil) -> SectionedPresenterProtocol? {
        return getPresent(vc) as? SectionedPresenterProtocol
    }
    
    public func getPlain(vc: ViewProtocolDelegate, _ completion: (()->Void)? = nil) -> PlainPresenterProtocol? {
        return getPresent(vc) as? PlainPresenterProtocol
    }
    
    private func getPresent(_ vc: ViewProtocolDelegate, _ completion: (()->Void)? = nil) -> PresenterProtocol? {
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
                       fatalError("Configurator: getPresenter - no presenter has found")
        }
    }
    
    
    public func getPresenter<T: PresenterProtocol>(vc: ViewProtocolDelegate, _ completion: (()->Void)? = nil) -> T? {
        let clazz = vc.className()
        var res: T? = view2Presenter[clazz] as? T
        
        if res == nil {
            res = createPresenter(vc, completion)
        } else {
            res?.setView(view: vc, completion: completion)
        }
        return res
    }
    
    
    private func createPresenter<T: PresenterProtocol>(_ vc: ViewProtocolDelegate, _ completion: (()->Void)? = nil) -> T? {
        let presenter: T = T(vc: vc, beginLoadFrom: .networkFirst, completion: completion)
        let clazz = vc.className()
        view2Presenter[clazz] = presenter
        presenters[clazz] = presenter
        return presenter
    }
    
    
    public func getPresenter<T: PresenterProtocol>(_ completion: (()->Void)? = nil) -> T? {
        let presenter: T = T(beginLoadFrom: .networkFirst, completion: completion)
        let clazz = String(describing: T.self)
        presenters[clazz] = presenter
        return presenter
    }
    
}
