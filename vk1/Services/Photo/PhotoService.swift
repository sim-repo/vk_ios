import UIKit


//lesson 5: Cache
class PhotoService {
    
    private init(){}
    
    public static var shared = PhotoService()
    
    private var images = [URL:UIImage]()
    
    private let cacheLifeTime: TimeInterval = 1 * 60 * 60 // 1 hour
    
    private static let imagesPathName: String = {
        let pathName = "images"
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName}
        let url = cacheDir.appendingPathComponent(cacheDir.absoluteString, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()
    
    private func getFilePath(url: URL) -> String? {
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil}
        let name = url.absoluteString.split(separator: "/").last ?? "default"
        return cacheDir.appendingPathComponent(PhotoService.imagesPathName + "." + name).path
    }
    
    private func saveImageToCache(url: URL, image: UIImage) {
        guard let fileName = getFilePath(url: url),
            let data = image.pngData() else { return }
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(url: URL) -> UIImage? {
        guard let fileName = getFilePath(url: url),
        let info = try? FileManager.default.attributesOfItem(atPath: fileName),
        let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else { return nil }
        
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return nil }
        
        let url = URL(string: url.absoluteString)!
        images[url] = image
        return image
    }
    
    
    func loadImage(presenter: ImageablePresenterProtocol, indexPath: IndexPath, url: URL) {
        
        if let image = images[url] {
            presenter.didImageLoad(indexPath: indexPath, image: image)
            return
        }
        
        if let image = getImageFromCache(url: url) {
            presenter.didImageLoad(indexPath: indexPath, image: image)
            return
        }
        
        
        NetworkPromiseRequest.imageRequest(url)
        .done { [weak self] image in
            if let image = image {
                self?.images[url] = image
                self?.saveImageToCache(url: url, image: image)
                presenter.didImageLoad(indexPath: indexPath, image: image)
            }
        }
        
    }
    
    func clear(){
        images.removeAll()
    }
}
