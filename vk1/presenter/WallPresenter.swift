import Foundation


public class WallPresenter: BasePresenter{
    
    var wall: [Wall]!
    
    override func initDataSource(){
        wall = Wall.list()
    }
    
    func numberOfRowsInSection() -> Int {
        return wall.count
    }
    
    func getImage(_ indexPath: IndexPath) -> String {
        return wall?[indexPath.row].image ?? ""
    }
}
