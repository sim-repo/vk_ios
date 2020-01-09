import UIKit
import Kingfisher
import AVFoundation

class Comment_AudioBlock: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var url: URL?
    var audioPlayer = AVPlayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(){
        Bundle.main.loadNibNamed("Comment_AudioBlock", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func pressPlay(_ sender: Any) {
        guard let url = url else { return }
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer.play()
        audioPlayer.automaticallyWaitsToMinimizeStalling = false
    }
}
