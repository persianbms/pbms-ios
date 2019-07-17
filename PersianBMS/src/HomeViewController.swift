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
    private var backButton: UIBarButtonItem!
    private var forwardButton: UIBarButtonItem!
    
    // need to retain this somewhere in memory so the observation isn't removed
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = l10n("home")
        self.tabBarItem = UITabBarItem(title: l10n("home"), image: #imageLiteral(resourceName: "outline_home_black_24pt"), tag: 1)
        
        backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "outline_arrow_back_ios_black_24pt"), style: .plain, target: self, action: #selector(onBackAction))
        backButton.isEnabled = false
        forwardButton = UIBarButtonItem(image: #imageLiteral(resourceName: "outline_arrow_forward_ios_black_24pt"), style: .plain, target: self, action: #selector(onForwardAction))
        forwardButton.isEnabled = false
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let reloadButton = UIBarButtonItem(image: #imageLiteral(resourceName: "outline_refresh_black_24pt"), style: .plain, target: self, action: #selector(onReloadAction))
        self.toolbarItems = [backButton, forwardButton, space, reloadButton]
//        self.hidesBottomBarWhenPushed = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        homeView = HomeView()
        homeView.webView.navigationDelegate = self
        homeView.webView.uiDelegate = self
        
        view = homeView
    }
    
    private func updateToolbarItemsState() {
        backButton.isEnabled = homeView.webView.canGoBack
        forwardButton.isEnabled = homeView.webView.canGoForward
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: User action handlers
    
    @objc private func onBackAction() {
        homeView.webView.goBack()
    }
    
    @objc private func onForwardAction() {
        homeView.webView.goForward()
    }
    
    @objc private func onReloadAction() {
        homeView.webView.reloadFromOrigin()
    }
}

extension HomeViewController: WKNavigationDelegate {
    
    
    // TODO: handle navigating off site/domain
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("should nav to \(navigationAction.request.url?.absoluteString ?? "empty")")
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
            print("external nav to: \(url.absoluteString)")
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
    // TODO: handle javascript pop ups
}
