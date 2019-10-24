import Foundation


public class NetworkManager {
    private init(){}
    
    static let shared = NetworkManager()
    
    var token: String?
    var userId: Int?
}
