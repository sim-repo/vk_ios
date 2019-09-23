import Foundation


public class ProfilePresenter: BasePresenter{

    var photos: [Photo]!
    
    override func initDataSource(){
        photos = Photo.list()
    }
    
    func numberOfRowsInSection() -> Int {
        return photos.count
    }
    
    func getImage(_ indexPath: IndexPath) -> String {
        return photos?[indexPath.row].image ?? ""
    }
}
