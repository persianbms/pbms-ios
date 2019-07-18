//
//  HomeView.swift
//  PersianBMS
//
//  Created by Arash on 7/2/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import WebKit

class HomeView: UIView {
    
    let liveStreamBar: LiveStreamBar
    let progressBar: UIProgressView
    let toolbar: UIToolbar
    let backButton: UIBarButtonItem
    let forwardButton: UIBarButtonItem
    let webView: WKWebView
    let controller: HomeViewController
    
    init(_ controller: HomeViewController) {
        self.controller = controller
        
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = true
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.applicationNameForUserAgent = "PBMS-iOS"
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progress = 0
        
        toolbar = UIToolbar(frame: .zero)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "outline_arrow_back_ios_black_24pt"), style: .plain, target: controller, action: #selector(HomeViewController.onBackAction))
        backButton.isEnabled = false
        forwardButton = UIBarButtonItem(image: #imageLiteral(resourceName: "outline_arrow_forward_ios_black_24pt"), style: .plain, target: controller, action: #selector(HomeViewController.onForwardAction))
        forwardButton.isEnabled = false
        let smallSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        smallSpace.width = 48
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let reloadButton = UIBarButtonItem(image: #imageLiteral(resourceName: "outline_refresh_black_24pt"), style: .plain, target: controller, action: #selector(HomeViewController.onReloadAction))
        toolbar.items = [backButton, smallSpace, forwardButton, space, reloadButton]
        
        liveStreamBar = LiveStreamBar(LiveStreamManager.shared)
        
        super.init(frame: .zero)
        
        addSubview(liveStreamBar)
        addSubview(webView)
        addSubview(progressBar)
        addSubview(toolbar)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        var liveStreamTopAnchor: NSLayoutYAxisAnchor = self.topAnchor
        if #available(iOS 11.0, *) {
            liveStreamTopAnchor = self.safeAreaLayoutGuide.topAnchor
        }
        
        NSLayoutConstraint.activate([
            liveStreamBar.topAnchor.constraint(equalTo: liveStreamTopAnchor),
            liveStreamBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            liveStreamBar.widthAnchor.constraint(equalTo: self.widthAnchor),
            liveStreamBar.heightAnchor.constraint(equalToConstant: 64),
        ])

        toolbar.sizeToFit()
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: toolbar.bounds.size.height),
        ])
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: liveStreamBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: toolbar.topAnchor)
            ])

        progressBar.sizeToFit()
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: progressBar.bounds.size.height)
        ])
    }
    
}
