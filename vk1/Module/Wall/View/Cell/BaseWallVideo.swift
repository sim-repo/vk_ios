import UIKit

class BaseWallVideo {
    
    var cellType: WallCellConstant.CellEnum!
    var videoService: VideoWebViewService?
    var buttons: [UIButton] = []
    
    
    internal func setup(buttons: [UIButton]) {
        cellType = .video
        self.buttons = buttons
        shouldShowPlayButton(isShow: true)
    }
    
    
    internal func pressImage(view: UIView) {
        if cellType == .video {
            videoService = VideoWebViewService()
            videoService?.setup(webviewContent: view)
            videoService?.startActivityIndicator()
        }
    }
    
    internal func prepareReuse(buttons: [UIButton]) {
        cellType = .none
        shouldShowPlayButton(isShow: false)
            //videoService?.prepareForReuse
    }
    
    
    internal func shouldShowPlayButton(isShow: Bool){
        let image = getSystemImage(name: "play.circle", pointSize: 50)
        for button in buttons {
            if isShow {
                button.setImage(image, for: .normal)
            } else {
                button.setImage(.none , for: .normal)
            }
        }
    }
    
    func play(url: URL, platformEnum: WallCellConstant.VideoPlatform) {
           shouldShowPlayButton(isShow: false)
           
           self.videoService?.playVideo(url: url, platformEnum: platformEnum) {[weak self] in
               guard let self = self else { return }
               if self.cellType == .video {
                   self.shouldShowPlayButton(isShow: true)
               }
           }
       }
    
    func showErr(err: String) {
        UI_THREAD { [weak self] in
            guard let self = self else { return }
            let image = getSystemImage(name: "exclamationmark.icloud", pointSize: 50)
            for button in self.buttons {
                button.setImage(image, for: .normal)
            }
            self.videoService?.stopActivityIndicator()
            self.videoService = nil
        }
    }
}
