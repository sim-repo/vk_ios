import Foundation

public class BasePresenter {
    
    func initDataSource(){}
    
    init(){
        initDataSource()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
}
