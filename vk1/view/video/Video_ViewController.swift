import UIKit

class Video_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let recognizer = UIPanGestureRecognizer(target: self,
                                                             action: #selector(handleGesture(_:)))
        self.view.addGestureRecognizer(recognizer)
    }
    
    @objc func handleGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
           
           switch recognizer.state {
               
               
           case .changed:
               let translation = recognizer.translation(in: recognizer.view)
               let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
               let progress = max(0, min(1, relativeTranslation))
               if progress > 0.33 {
                   dismiss(animated: true, completion: nil)
               }
           default: return
           }
       }

}
