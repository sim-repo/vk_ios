import Foundation



func UI_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.main.async(execute: block)
}


private let serialQueue = DispatchQueue(label: "")

func SEQ_THREAD(_ block: @escaping (() -> Void)) {
    serialQueue.async(execute: block)
}


func USER_INITIATED_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.global(qos: .userInitiated).async(execute: block)
}
