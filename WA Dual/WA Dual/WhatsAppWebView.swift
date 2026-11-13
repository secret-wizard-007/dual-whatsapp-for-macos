import SwiftUI
import WebKit
import Combine

/// Owns a dedicated, persistent cookie store so this app’s WhatsApp login
/// stays separate from Safari and the official WhatsApp Mac app.
final class WhatsAppSession: ObservableObject {
    @Published var isLoading = true

    let webView: WKWebView

    private let dataStore: WKWebsiteDataStore
    private var observations: [NSKeyValueObservation] = []

    init() {
        let storeID = UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567890")!
        dataStore = WKWebsiteDataStore(forIdentifier: storeID)

        let config = WKWebViewConfiguration()
        config.websiteDataStore = dataStore
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.mediaTypesRequiringUserActionForPlayback = []

        if #available(macOS 14.0, *) {
            config.preferences.isElementFullscreenEnabled = true
        }

        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs

        webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = Self.chromeUserAgent
        webView.allowsBackForwardNavigationGestures = false
        webView.allowsMagnification = true

        observations.append(
            webView.observe(\.isLoading, options: [.new]) { [weak self] view, _ in
                DispatchQueue.main.async {
                    self?.isLoading = view.isLoading
                }
            }
        )

        loadHome()
    }

    func reload() {
        webView.reload()
    }

    func clearSessionAndReload() {
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        dataStore.removeData(ofTypes: types, modifiedSince: .distantPast) { [weak self] in
            DispatchQueue.main.async {
                self?.loadHome()
            }
        }
    }

    private func loadHome() {
        guard let url = URL(string: "https://web.whatsapp.com") else { return }
        webView.load(URLRequest(url: url))
    }

    /// Desktop Chrome UA — WhatsApp Web is picky about mobile / odd agents.
    private static var chromeUserAgent: String {
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
    }
}

struct WhatsAppWebView: NSViewRepresentable {
    @ObservedObject var session: WhatsAppSession

    func makeNSView(context: Context) -> WKWebView {
        session.webView.navigationDelegate = context.coordinator
        session.webView.uiDelegate = context.coordinator
        return session.webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            // Keep WhatsApp inside the app; open external links in the browser.
            let host = url.host?.lowercased() ?? ""
            let isWhatsApp =
                host.contains("whatsapp.com")
                || host.contains("whatsapp.net")
                || host.contains("facebook.com")
                || host.contains("fbcdn.net")
                || host.isEmpty
                || url.scheme == "blob"
                || url.scheme == "about"

            if isWhatsApp || navigationAction.targetFrame != nil {
                decisionHandler(.allow)
            } else {
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
            }
        }

        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            if let url = navigationAction.request.url {
                NSWorkspace.shared.open(url)
            }
            return nil
        }

        func webView(
            _ webView: WKWebView,
            requestMediaCapturePermissionFor origin: WKSecurityOrigin,
            initiatedByFrame frame: WKFrameInfo,
            type: WKMediaCaptureType,
            decisionHandler: @escaping (WKPermissionDecision) -> Void
        ) {
            decisionHandler(.grant)
        }
    }
}
