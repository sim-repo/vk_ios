import UIKit

class NewsCommentUser_TableViewCell: UITableViewCell {

    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tailBubbleMsgView: UIView!
    @IBOutlet weak var bubbleMsgImageView: UIImageView!
    
    var comment: Comment!
    var audioSizeBlock: CGFloat = 0
    
    
    static func clazz() -> String {
        return String(describing: NewsCommentUser_TableViewCell.self)
    }
    
    static func id() -> String {
        return String(describing: NewsCommentUser_TableViewCell.self)
    }
    
    func setup(_ comment: Comment) {
        reset()
        avaImageView.kf.setImage(with: comment.avaURL50)
        nameLabel.text = comment.firstName + " " + comment.lastName
        dateLabel.text = convertUnixTime(unixTime: comment.date)
        if comment.text.count > 0 {
            commentLabel.isHidden = false
            tailBubbleMsgView.isHidden = false
            commentLabel.text = "\n" + comment.text + "\n"
        }
        self.comment = comment
        addAudioBlock()
    }
    
    private func addAudioBlock(){
        let audio = comment.audio
        guard audio.count > 0 else { return }
        audioSizeBlock = CGFloat(audio.count * 35)
        for element in audio {
            let audioView = Comment_AudioBlock()
            audioView.nameLabel.text = element.artist + "  -  " + element.title
            audioView.url = element.url
            stackView.addArrangedSubview(audioView)
            audioView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        }
    }
    
    
    private func reset(){
        tailBubbleMsgView.isHidden = true
        commentLabel.isHidden = true
        UIControlThemeMgt.renderImage(imageView: bubbleMsgImageView, color: #colorLiteral(red: 0.32472682, green: 0.04594633728, blue: 0.6819890738, alpha: 1))
        audioSizeBlock = 0
        avaImageView.image = UIImage(named: "placeholder")
        nameLabel.text = ""
        commentLabel.text = ""
        dateLabel.text = ""
        let subviews = stackView.subviews
        for element in subviews {
            if element is Comment_AudioBlock {
                element.removeFromSuperview()
            }
        }
    }
    
    override func prepareForReuse() {
          audioSizeBlock = 0
          avaImageView.image = UIImage(named: "placeholder")
          nameLabel.text = ""
          commentLabel.text = ""
          dateLabel.text = ""
          let subviews = stackView.subviews
          for element in subviews {
              if element is Comment_AudioBlock {
                  element.removeFromSuperview()
              }
          }
      }
    

}
