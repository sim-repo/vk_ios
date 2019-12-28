import UIKit
import WebKit
import AVKit

class VideoWebViewService: NSObject {
    
    var webview: WKWebView? {
        didSet {
            webview?.navigationDelegate = self
        }
    }
    
    var isMute = true
    var webviewContent: UIView!
    var activityView: UIActivityIndicatorView?
    var blackView: UIView?
    var completion: (()->Void)?
    
    
    func setup(webviewContent: UIView) {
        self.webviewContent = webviewContent
    }
    
    
    func inject(webview: WKWebView) {
        ViewDidAppearInjector.inject(into: [AVPlayerViewController.self]) {
            if let p = $0 as? AVPlayerViewController {
                self.add(vc: p)
            }
        }
    }
    
    
    func startActivityIndicator() {
        
        blackView = UIView(frame: webviewContent.bounds)
        blackView?.backgroundColor = .black
        blackView?.alpha = 0
        webviewContent.addSubview(blackView!)
        
        self.activityView = UIActivityIndicatorView(style: .large)
        self.activityView?.center = CGPoint(x: self.webviewContent.bounds.midX, y: self.webviewContent.bounds.midY)
        self.activityView?.color = ColorSystemHelper.secondary
        self.webviewContent?.addSubview(self.activityView!)
        self.activityView?.startAnimating()
        
        UIView.animate(
            withDuration: 1,
            animations: { [weak self] in
                self?.blackView!.alpha = 1.0
                self?.webviewContent.layoutIfNeeded()
            })
    }
    
    func stopActivityIndicator() {
        blackView?.removeFromSuperview()
        blackView = nil
        activityView?.stopAnimating()
        activityView?.removeFromSuperview()
        webviewContent?.layoutIfNeeded()
    }
    
    
    func createYouTubeWebView(url: URL){
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.mediaPlaybackRequiresUserAction = false
        config.allowsInlineMediaPlayback = false
        let source = "document.addEventListener('stopVideoEvent', function(){ window.webkit.messageHandlers.iosListener.postMessage('Did Video Stop'); })"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        
        config.userContentController.add(self, name: "iosListener")
        webview = WKWebView(frame: CGRect(x: 0, y: 0, width: webviewContent!.bounds.width, height: webviewContent!.bounds.height), configuration: config)
        
        webview?.translatesAutoresizingMaskIntoConstraints = false
        webview?.isOpaque = false
        webview?.backgroundColor = .clear
        webview?.scrollView.backgroundColor = .clear
        let htmlConfig = YouTubeConfigHTML.getConfig(sURL: url.absoluteString)
        webview?.loadHTMLString(htmlConfig, baseURL: nil)
        webviewContent?.addSubview(webview!)
        
        inject(webview: webview!)
    }
    
    
    func createOtherWebView(url: URL) {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.mediaPlaybackRequiresUserAction = false
        config.allowsInlineMediaPlayback = true
        
        webview = WKWebView(frame: webviewContent!.bounds, configuration: config)
        webview?.isOpaque = false
        webview?.backgroundColor = .clear
        webview?.scrollView.backgroundColor = UIColor.clear
        webview?.translatesAutoresizingMaskIntoConstraints = false
        
        inject(webview: webview!)
        
        let sURL = url.absoluteString + "&?playsinline=1&autoplay=1&controls=2"
        let url2 = URL(string: sURL)
        let request:URLRequest = URLRequest(url: url2!)
        webview?.load(request)
        
    }
    
    
    public func prepareForReuse() {
        blackView?.removeFromSuperview()
        blackView = nil
        activityView?.removeFromSuperview()
        activityView = nil
        webview?.removeFromSuperview()
        webview = nil
    }
    
    
    public func playVideo(url: URL, platformEnum: WallCellConstant.VideoPlatform, completion: (()->Void)? = nil) {
        self.completion = completion
        switch platformEnum {
        case .youtube:
            createYouTubeWebView(url: url)
        case .other:
            createOtherWebView(url: url)
        case .null:
            Logger.catchError(msg: "VideoWebViewMgt(): playVideo: case exception")
        }
    }
    
    public func stopVideo(){
        webview?.removeFromSuperview()
        webview = nil
    }
    
    public func changeSound(mute: Bool){
        let calledSoundJsFuncion = mute ? "muteVideo()" : "unmuteVideo()"
        webview?.evaluateJavaScript(calledSoundJsFuncion) { result, error in
            guard error == nil else {
                // print(error)
                return
            }
        }
    }
}


//You Tube:
extension VideoWebViewService: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // comment out if needed!
        // print("message: \(message.body)")
        // webview?.removeFromSuperview()
    }
}



extension VideoWebViewService: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivityIndicator()
        webviewContent?.addSubview(webview!)
    }
}

//Other Web View:
extension VideoWebViewService {
    
    func add(vc: AVPlayerViewController) {
        vc.addObserver(self, forKeyPath: #keyPath(AVPlayerViewController.view.frame), options: [.old, .new, .initial], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerViewController.view.frame) {
            
            guard let change = change else {
                return
            }
            
            if let _ = change[.oldKey] {
                PRESENTER_UI_THREAD { [weak self] in
                    UIView.animate(withDuration: 2,
                                   animations: {
                                    self?.webview?.alpha = 0.1
                                    self?.webview?.layoutIfNeeded()},
                                   completion: { _ in
                                    self?.webview?.removeFromSuperview()
                                    self?.webview = nil
                                    self?.completion?()})
                }
            }
        }
    }
}
