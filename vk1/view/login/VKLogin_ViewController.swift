import UIKit
import WebKit

class VKLogin_ViewController: UIViewController {
    
    
    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlComponents = URLComponents()
               urlComponents.scheme = "https"
               urlComponents.host = "oauth.vk.com"
               urlComponents.path = "/authorize"
               urlComponents.queryItems = [
                   URLQueryItem(name: "client_id", value: "7189984"),
                   URLQueryItem(name: "display", value: "mobile"),
                   URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                   URLQueryItem(name: "scope", value: "262150"),
                   URLQueryItem(name: "response_type", value: "token"),
                   URLQueryItem(name: "v", value: "5.87")
               ]
               
        let request = URLRequest(url: urlComponents.url!)
               
        webview.load(request)
    }
}


extension VKLogin_ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment
            else {
                    decisionHandler(.allow)
                    return
            }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        guard let token = params["access_token"], let userId = Int(params["user_id"]!) else {
            decisionHandler(.cancel)
            return
        }
        
        print(token, userId)
        Session.shared.token = token
        Session.shared.userId = userId
        performSegue(withIdentifier: "ShowMainSegue", sender: nil)
        decisionHandler(.cancel)
        
    }
}
