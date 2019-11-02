import UIKit


// Class-Factory for creating and storing presenters
class PresenterFactory {
    
    static let shared = PresenterFactory()
    private init(){}

    // store
    private lazy var presenters: [ModuleEnum:PresenterProtocol] = [:]
    
    
    //MARK: called from Synchronizer >>
    
    public func getInstance<T: PresenterProtocol>() -> T {
        if let presenter: T = getPresenter() {
            return presenter
        }
        
        let presenter: T = T()
        let presenterEnum = ModuleEnum(presenter: presenter)
        presenters[presenterEnum] = presenter
        return presenter
    }
    
    public func getPresenter<T: PresenterProtocol>() -> T? {
        let presenterEnum = ModuleEnum(presenterType: T.self)
        let res: T? = presenters[presenterEnum] as? T
        return res
    }
    

    //MARK: viewDidLoad called from VC >>
    
    public func getSectioned(viewDidLoad vc: ViewInputProtocol, _ completion: (()->Void)? = nil) -> SectionedPresenterProtocol? {
        return getPresenter(viewDidLoad: vc) as? SectionedPresenterProtocol
    }
    
    public func getPlain(viewDidLoad vc: ViewInputProtocol, _ completion: (()->Void)? = nil) -> PlainPresenterProtocol? {
        return getPresenter(viewDidLoad: vc) as? PlainPresenterProtocol
    }
    

    // private methods
    
    private func getPresenter(viewDidLoad vc: ViewInputProtocol, _ completion: (()->Void)? = nil) -> PresenterProtocol? {
        
        let presenterEnum = ModuleEnum(vc: vc)
        
        var presenter = presenters[presenterEnum]
        
        if presenter == nil {
            presenter = createPresenter(clazz: presenterEnum.presenter, vc, completion)
        } else {
            presenter?.setView(view: vc, completion: completion)
        }
        SynchronizerManager.shared.viewDidLoad(presenterEnum: presenterEnum)
        return presenter
    }
    
    
    private func createPresenter(clazz: PresenterProtocol.Type, _ vc: ViewInputProtocol, _ completion: (()->Void)? = nil) -> PresenterProtocol? {
        let presenter = clazz.init(vc: vc, completion: completion)
        let presenterEnum = ModuleEnum(presenter: presenter)
        presenters[presenterEnum] = presenter
        return presenter
    }
  
}
