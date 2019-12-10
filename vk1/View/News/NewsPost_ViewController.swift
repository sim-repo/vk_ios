import UIKit
import Kingfisher

class NewsPost_ViewController: UIViewController {
    
    @IBOutlet weak var prototypeImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var postTextView: MyTextView_OnBackground!
    
    var selectedImageIdx = 0
    
    var swipeAnimator: UIViewPropertyAnimator?
    var constainerContentSize: CGFloat!
    
    var news: News!
    var images: [UIImageView] = []
    var currNumTouch = 0
    var maxTouches = 0
    var prevTouch: CGPoint!
    var isNewSwipe = true
    let standardItemScale: CGFloat = 0.1
    
    
    override func viewDidLoad() {
        let swipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        imageContainerView.addGestureRecognizer(swipeRecognizer)
        prepareForViewAnimator()
        postTextView.text = news.getOrigTitle()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        swipeAnimator?.stopAnimation(true)
        //  imageContainerView.removeFromSuperview()
    }
    
    
    private func prepareForViewAnimator(){
        
        var imageURLs = [URL]()
        guard news.imageURLs.count >= selectedImageIdx + 1
            else {
                Logger.catchError(msg: "FriendPost_ViewController(): prepareForViewAnimator(): index out of range: \(selectedImageIdx)")
                return
        }
        imageURLs.append(news.imageURLs[selectedImageIdx])
        
        for (idx, url) in news.imageURLs.enumerated() {
            if idx != selectedImageIdx {
                imageURLs.append(url)
            }
        }
        
        for (idx, url) in imageURLs.enumerated() {
            
            let imageView = UIImageView()
            imageView.kf.setImage(with: url)
            let half = prototypeImageView.frame.size.width/2
            let dx = prototypeImageView.frame.size.width * CGFloat(idx) + wScreen / 2.0 - half
            imageView.frame = CGRect(x: dx, y: 0, width: prototypeImageView.frame.width, height: prototypeImageView.frame.height)
            imageView.contentMode = .scaleAspectFit
            images.append(imageView)
            prototypeImageView.addSubview(imageView)
        }
        maxTouches = news.imageURLs.count
        constainerContentSize = prototypeImageView.frame.width
    }
    
    
    func initSwipeAnimator(dx: CGFloat, sign: CGFloat){
        
        swipeAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5, animations: {
            self.images.forEach({ image in
                
                let maxDistance:CGFloat = 100
                let distance = min(abs(self.imageContainerView.frame.midX - abs(image.frame.midX + sign * self.constainerContentSize)), maxDistance)
                let ratio = (maxDistance - distance)/maxDistance
                let scale = ratio * (1 - self.standardItemScale) + self.standardItemScale
                image.transform = CGAffineTransform(translationX:dx , y: 0).concatenating(CGAffineTransform(scaleX: 1, y: scale))
                image.alpha = scale
            })
        })
        swipeAnimator?.startAnimation()
        swipeAnimator?.pauseAnimation()
    }
    
    @objc func didSwipe(_ recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .changed:
            let currTouch = recognizer.translation(in: self.imageContainerView)
            
            var sign: CGFloat = 1
            switch recognizer.direction {
            case .right:
                sign = 1
            case .left:
                sign = -1
            default:
                return
            }
            swipeAnimator?.fractionComplete =  sign * (currTouch.x / 500)
            if isNewSwipe {
                if prevTouch == nil {
                    prevTouch = currTouch
                    return
                }
                if prevTouch.x > currTouch.x {
                    guard currNumTouch < maxTouches - 1 else {return}
                    
                    currNumTouch += 1
                    isNewSwipe = false
                    initSwipeAnimator(dx: -(self.constainerContentSize * CGFloat(self.currNumTouch)), sign: -1)
                }
                if prevTouch.x < currTouch.x
                {
                    guard currNumTouch > 0 else {return}
                    currNumTouch -= 1
                    isNewSwipe = false
                    initSwipeAnimator(dx: -(self.constainerContentSize * CGFloat(self.currNumTouch)), sign: 1)
                }
            }
        case .ended:
            prevTouch = nil
            isNewSwipe = true
            swipeAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default: return
            
        }
    }
}


