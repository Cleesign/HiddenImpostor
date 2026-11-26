import SwiftUI
import UIKit
import WebKit

/// Full-screen web view that runs the bundled game (Web/index.html) offline.
struct GameView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()

        // Tell the page it runs inside the app, and route navigator.vibrate() to real iPhone haptics.
        let bridge = """
        window.HI_NATIVE_APP = true;
        navigator.vibrate = function (p) {
          var ms = Array.isArray(p) ? (p[0] || 0) : (p || 0);
          try { window.webkit.messageHandlers.haptic.postMessage(ms | 0); } catch (e) {}
          return true;
        };
        """
        contentController.addUserScript(WKUserScript(source: bridge, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        contentController.add(context.coordinator, name: "haptic")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.websiteDataStore = .default() // keeps players and leaderboard (localStorage) between launches

        let webView = WKWebView(frame: .zero, configuration: config)
        let night = UIColor(red: 10 / 255, green: 11 / 255, blue: 30 / 255, alpha: 1)
        webView.isOpaque = false
        webView.backgroundColor = night
        webView.scrollView.backgroundColor = night
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never // the page handles safe areas itself
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = false
        if #available(iOS 16.4, *) { webView.isInspectable = true }

        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Web") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKScriptMessageHandler {
        private let light = UIImpactFeedbackGenerator(style: .light)
        private let medium = UIImpactFeedbackGenerator(style: .medium)

        func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "haptic" else { return }
            let ms = (message.body as? NSNumber)?.intValue ?? 12
            (ms >= 20 ? medium : light).impactOccurred()
        }
    }
}
