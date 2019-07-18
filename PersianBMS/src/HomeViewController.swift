//
//  HomeViewController.swift
//  PersianBMS
//
//  Created by Arash on 7/2/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit
import WebKit
import CoreServices
import CoreText

class HomeViewController: UIViewController {
    
    let acceptableHostSuffixes: [String] = ["persianbahaimedia.org", "addtoany.com"]
    private var homeView: HomeView!
    
    // need to retain this somewhere in memory so the observation isn't removed
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = l10n("home")
        self.tabBarItem = UITabBarItem(title: l10n("home"), image: #imageLiteral(resourceName: "outline_home_black_24pt"), tag: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        homeView = HomeView(self)
        homeView.webView.navigationDelegate = self
        homeView.webView.uiDelegate = self
        
        view = homeView
    }
    
    private func updateToolbarItemsState() {
        homeView.backButton.isEnabled = homeView.webView.canGoBack
        homeView.forwardButton.isEnabled = homeView.webView.canGoForward
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObserver = homeView.webView.observe(\.estimatedProgress, options: [.new]) { (_, _) in
            let progress = Float(self.homeView.webView.estimatedProgress)
            self.homeView.progressBar.progress = progress
            if progress < 1 {
                self.homeView.progressBar.alpha = 1
            } else {
                UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
                    self.homeView.progressBar.alpha = 0
                }, completion: nil)
            }
        }
        
        let url = URL(string: "https://persianbahaimedia.org/")!
        let req = URLRequest(url: url)
        homeView.webView.load(req)
        
        edgesForExtendedLayout = []
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: User action handlers
    
    @objc func onBackAction() {
        homeView.webView.goBack()
    }
    
    @objc func onForwardAction() {
        homeView.webView.goForward()
    }
    
    @objc func onReloadAction() {
        homeView.webView.reloadFromOrigin()
    }
}

extension HomeViewController: WKNavigationDelegate {
    
    
    // TODO: handle navigating off site/domain
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        guard let scheme = url.scheme else {
            // not sure when this could happen
            decisionHandler(.allow)
            return
        }
        
        // easy decision
        if scheme == "mailto" {
            decisionHandler(.cancel)
            UIPasteboard.general.string = url.absoluteString
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }
        
        guard let host = url.host else {
            // how would this happen?
            decisionHandler(.allow)
            return
        }
        
        for suffix in acceptableHostSuffixes {
            if host.hasSuffix(suffix) {
                decisionHandler(.allow)
                return
            }
        }
        
        decisionHandler(.cancel)
        // redirect to the external url handler
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        print("did commit: \(String(describing: navigation))")
        updateToolbarItemsState()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("did finish: \(String(describing: navigation))")
        updateToolbarItemsState()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        print("did fail with error: \(error)")
        updateToolbarItemsState()
    }
}

extension HomeViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: "\(frame.request.url!.host!) says:", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: l10n("ok"), style: .default, handler: { (action) in
            completionHandler()
        }))
        present(ac, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let ac = UIAlertController(title: "\(frame.request.url!.host!) says:", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: l10n("ok"), style: .default, handler: { (action) in
            completionHandler(true)
        }))
        ac.addAction(UIAlertAction(title: l10n("cancel"), style: .cancel, handler: { (action) in
            completionHandler(false)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let ac = UIAlertController(title: "\(frame.request.url!.host!) asks:", message: prompt, preferredStyle: .alert)
        ac.addTextField { (tf) in
            tf.placeholder = defaultText
        }
        ac.addAction(UIAlertAction(title: l10n("ok"), style: .default, handler: { (action) in
            completionHandler(ac.textFields![0].text!)
        }))
        ac.addAction(UIAlertAction(title: l10n("cancel"), style: .cancel, handler: { (action) in
            completionHandler(nil)
        }))
    }
}
