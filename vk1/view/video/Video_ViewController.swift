import UIKit

class Video_ViewController: UIViewController {

    @IBOutlet weak var bkgView: MyView_GradiendBackground!
    override func viewDidLoad() {
        super.viewDidLoad()

        let recognizer = UIPanGestureRecognizer(target: self,
                                                             action: #selector(handleGesture(_:)))
        self.bkgView.addGestureRecognizer(recognizer)
    }
    
    @objc func handleGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
           
           switch recognizer.state {
               
               
           case .changed:
               let translation = recognizer.translation(in: recognizer.view)
               let relativeTranslation = translation.y / (recognizer.view?.bounds.height ?? 1)
               let progress = max(0, min(1, relativeTranslation))
               if progress > 0.2 {
                //navigationController?.popViewController(animated: true)
                   dismiss(animated: true, completion: nil)
               }
           default: return
           }
       }

}
