import UIKit



protocol ImageablePresenterProtocol: class {
    func tryImageLoad(indexPath: IndexPath, url: URL)
    func didImageLoad(indexPath: IndexPath, image: UIImage)
    func didReceiveMemoryWarning()
}
