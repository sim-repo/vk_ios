import Foundation

//MARK:- called from coordinate

extension BaseIndexingPresenter : CoordinatableIndexingPresenterProtocol {
    func setView(view: PresentableViewProtocol) {
        self.view = view
        
        if let multiple = self as? MultiplePresenterProtocol {
            multiple.didSetView()
        }
        
        if dataSource.isEmpty {
            waitIndicator(start: true)
        } else {
            viewReloadData()
        }
        // update if needed all sub-presenters
        (self as? MultiplePresenterProtocol)?.didSetView()
    }
}
    
