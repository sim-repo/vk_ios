import Foundation
import Alamofire

// complex presenter
// has child presenter: #child
class MyGroupDetailPresenter: PlainPresenterProtocols {
    
    var modelClass: AnyClass  {
        return DetailGroup.self
    }
       
    var detailModel: ModelProtocol?
    
    
    // #child begin
    var myGroupWallPresenter = PresenterFactory.shared.getInstance(clazz:  MyGroupWallPresenter.self) as? DetailPresenterProtocol & SynchronizedPresenterProtocol & PullPlainPresenterProtocol
    
    required init() {
        super.init()
        plainChildPresenter = myGroupWallPresenter
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
    override func save(validated: [PlainModelProtocol]) {
        let detailGroup = validated[0] as! DetailGroup
        guard let group = detailModel as? MyGroup
        else {
            catchError(msg: "\(clazz): save(): detailModel is incorrect")
            return
        }
        detailGroup.setup(group: group)
        super.didSave()
    }
}


extension MyGroupDetailPresenter: DetailPresenterProtocol {
    
    func setDetailModel(model: ModelProtocol) {
        self.detailModel = model
        
        //setup child presenter
        guard let detailPresenter = myGroupWallPresenter,
              let detail = detailModel
        else {
            catchError(msg: "\(clazz): setDetailModel(): myGroupWallPresenter or detailModel is nil")
            return
        }
        // #child begin
        detailPresenter.setDetailModel(model: detail)
        SynchronizerManager.shared.callSyncFromPresenter(moduleEnum: .my_group_wall)
        // #child end
    }
    
    func getId() -> typeId? {
        guard let passed = detailModel
        else {
            catchError(msg: "\(clazz): getId(): modelPassedThrowSegue is nil")
            return nil
        }
        return passed.getId()
    }
}

