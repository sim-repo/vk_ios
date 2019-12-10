import Foundation
import WebKit



struct OtherConfigHTML {
    
    static func getConfig(url: String) -> String {
        return """
        <iframe src="\(url)&autoplay=1&playsinline=1" width="768" height="1365" frameborder="0" allowFullScreen></iframe>
        """
    }
        
}
