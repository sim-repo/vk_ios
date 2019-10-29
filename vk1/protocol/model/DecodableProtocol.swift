import Foundation
import SwiftyJSON

protocol DecodableProtocol: class {
    init() // need for AlamofireNetworkManager.parseJSON
    func setup(json: JSON?)
}
