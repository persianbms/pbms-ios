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
    let webView: WKWebView
    
    init() {
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
        
        liveStreamBar = LiveStreamBar(LiveStreamManager.shared)
        
        super.init(frame: .zero)
        
        addSubview(liveStreamBar)
        addSubview(webView)
        addSubview(progressBar)
        
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
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: liveStreamBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        progressBar.sizeToFit()
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: progressBar.bounds.size.height)
        ])
    }
    
}
