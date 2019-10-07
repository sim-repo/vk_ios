import Foundation


public class WallPresenter: BasePresenter{
    
    var wall: [Wall]!
    
    override func initDataSource(){
        wall = Wall.list()
    }
    
    func numberOfRowsInSection() -> Int {
        return wall.count
    }
    
    func getImages(_ indexPath: IndexPath) -> [String]? {
        return wall?[indexPath.row].imageURLs
    }
    
    func getData(_ indexPath: IndexPath) -> Wall? {
        return wall?[indexPath.row]
    }
}
