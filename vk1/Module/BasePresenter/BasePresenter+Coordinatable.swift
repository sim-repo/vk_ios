import Foundation

//MARK:- called from coordinate

extension BasePresenter : CoordinatablePresenterProtocol {
    
    func setView(view: PresentableViewProtocol) {
        self.view = view as? PresentablePlainViewProtocol
        if dataSource.isEmpty {
            waitIndicator(start: true)
        } else {
            viewReloadData()
        }
        // update if needed all sub-presenters
        (self as? MultiplePresenterProtocol)?.didSetView()
    }
}
    
