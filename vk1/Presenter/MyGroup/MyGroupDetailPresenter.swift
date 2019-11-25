import Foundation

// complex presenter
// has child presenter: #child
class MyGroupDetailPresenter: PlainPresenterProtocols {
    
    
    var netFinishViewReload: Bool = true
    
    
    var modelClass: AnyClass  {
        return DetailGroup.self
    }
       
    var parentModel: ModelProtocol?
    
    
    // #child begin
    var myGroupWallPresenter = PresenterFactory.shared.getInstance(clazz:  MyGroupWallPresenter.self) as? DetailPresenterProtocol & SynchronizedPresenterProtocol & PullPlainPresenterProtocol
    
    required init() {
        super.init()
        subPlainPresenter = myGroupWallPresenter
        didSetViewCompletion = { [weak self] (view) in
            guard let self = self else { return }
            guard let v = view else {
                catchError(msg: "\(self.clazz): save(): didSetViewCompletion view is nil")
                return
            }
            self.myGroupWallPresenter?.setView(vc: v)
        }
    }
    // #child end

    
    //MARK: override func
    override func enrichData(validated: [PlainModelProtocol]) -> [PlainModelProtocol]? {
        let detailGroup = validated[0] as! DetailGroup
        guard let group = parentModel as? MyGroup
        else {
            catchError(msg: "\(clazz): enrichData(): detailModel is incorrect")
            return nil
        }
        //enrich
        detailGroup.setup(group: group)
        return [detailGroup]
    }
}


extension MyGroupDetailPresenter: DetailPresenterProtocol {
    
    func setParentModel(model: ModelProtocol) {
        self.parentModel = model
        
        //setup child presenter
        guard let detailPresenter = myGroupWallPresenter,
              let detail = parentModel
        else {
            catchError(msg: "\(clazz): setDetailModel(): myGroupWallPresenter or detailModel is nil")
            return
        }
        // #child begin
        detailPresenter.setParentModel(model: detail)
        SynchronizerManager.shared.doSync(moduleEnum: .my_group_wall)
        // #child end
    }
    
    func getId() -> typeId? {
        guard let passed = parentModel
        else {
            catchError(msg: "\(clazz): getId(): modelPassedThrowSegue is nil")
            return nil
        }
        return passed.getId()
    }
}

