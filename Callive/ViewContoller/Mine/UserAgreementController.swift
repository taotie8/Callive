
import UIKit
import WebKit

class UserAgreementController: UIViewController {

    @IBOutlet weak var wk_title: UILabel!
    @IBOutlet weak var wk_gressView: UIProgressView!
    @IBOutlet weak var wk_webView: WKWebView!

    var pageTitle: String = "Privacy Policy"
    var urlString: String = ""

    private var progressObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        wk_title.text = pageTitle
        wk_webView.backgroundColor = .clear
        wk_webView.navigationDelegate = self
        wk_webView.allowsBackForwardNavigationGestures = true
        wk_webView.scrollView.alwaysBounceVertical = true

        wk_gressView.progress = 0
        wk_gressView.isHidden = true

        progressObservation = wk_webView.observe(
            \WKWebView.estimatedProgress,
            options: [.new]
        ) { [weak self] webView, _ in
            self?.wk_gressView.progress = Float(webView.estimatedProgress)
        }

        loadPage()
    }

    private func loadPage() {
        guard let url = URL(string: urlString),
              let scheme = url.scheme,
              ["http", "https"].contains(scheme.lowercased()) else {
            wk_gressView.isHidden = true
            return
        }

        wk_webView.load(URLRequest(url: url))
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension UserAgreementController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        wk_gressView.progress = 0
        wk_gressView.isHidden = false
    }

    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        wk_gressView.setProgress(1, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.wk_gressView.isHidden = true
        }
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        wk_gressView.isHidden = true
        print("协议页面加载失败：\(error.localizedDescription)")
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        wk_gressView.isHidden = true
        print("协议页面加载失败：\(error.localizedDescription)")
    }
}
