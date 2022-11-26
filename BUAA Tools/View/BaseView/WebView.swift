//
//  WebView.swift
//  BUAA Tools
//
//  First created on Toby's iPad
//
//  Thanks for the tutorial from https://benoitpasquier.com/create-webview-in-swiftui/
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let webView: WKWebView

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

class WebViewModel: ObservableObject {
    private let navigationDelegate = WebViewNavigationDelegate()
    let webView: WKWebView = WKWebView(frame: .zero)
    var url: URL? = nil
    
    init() {
        webView.navigationDelegate = navigationDelegate
    }
    
    func loadUrl(url: URL) -> WKWebView {
//        print("Load URL: \(url)")
        let cookiesStore = webView.configuration.websiteDataStore.httpCookieStore
        if let cookies = URLSession.shared.configuration.httpCookieStorage?.cookies {
            cookies.forEach { cookie in
                cookiesStore.setCookie(cookie)
            }
        }
        webView.load(URLRequest(url: url))
        return webView
    }
}

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    // 处理拨打电话以及Url跳转等等，来自 https://blog.csdn.net/wm9028/article/details/89644305
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if navigationAction.request.url != nil {
            debugPrint("decidePolicyForurl == \(navigationAction.request.url!)");
        } else {
            debugPrint("decidePolicyForurl == nil!")
        }
        if navigationAction.request.url?.scheme == "tel" {
            //            DispatchQueue.main.async {
            UIApplication.shared.open(navigationAction.request.url!);
            decisionHandler(WKNavigationActionPolicy.cancel)
            //            }
        }
        else if navigationAction.request.url?.scheme == "sms"{
            //短信的处理
            UIApplication.shared.open(navigationAction.request.url!);
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        else if navigationAction.request.url?.scheme == "mailto"{
            //邮件的处理
            UIApplication.shared.open(navigationAction.request.url!);
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        else if navigationAction.request.url?.scheme == "alipay" || navigationAction.request.url?.scheme == "weixin" {
            UIApplication.shared.open(navigationAction.request.url!, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false])
            decisionHandler(WKNavigationActionPolicy.allow)
        }
        else{
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
}

struct WebViewDemoPage_Previews: PreviewProvider {
    static let webViewModel = WebViewModel()
    static var previews: some View {
        WebView(webView: webViewModel.loadUrl(url: URL(string: "https://benoitpasquier.com/create-webview-in-swiftui/")!))
    }
}
