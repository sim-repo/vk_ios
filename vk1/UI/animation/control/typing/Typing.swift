import UIKit


extension UILabel {
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 5.0) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for (idx, character) in typedText.enumerated() {
                DispatchQueue.main.async {
                    if idx > 0 {
                        weakSelf?.text!.removeLast()
                    }
                    weakSelf?.text!.append(character)
                    if idx < typedText.count-1 {
                        weakSelf?.text!.append("_")
                    }
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }

        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }

}
