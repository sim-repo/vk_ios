import Foundation


public class ProfilePresenter: SectionedBasePresenter {

    var photos: [Photo]!
    
    
    func numberOfRowsInSection() -> Int {
        return photos.count
    }
    
    func getImage(_ indexPath: IndexPath) -> String {
        return photos?[indexPath.row].imageURL ?? ""
    }
}
