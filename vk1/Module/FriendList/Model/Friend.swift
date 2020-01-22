import Foundation


class Friend: ModelProtocol {
    
    var id = 0
    var firstName = ""
    var lastName = ""
    var avaURL50: URL?
    var avaURL100: URL?
    var avaURL200: URL?
    
    func getId() -> Int {
        id
    }
}
