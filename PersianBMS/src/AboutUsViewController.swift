//
//  AboutUsViewController.swift
//  PersianBMS
//
//  Created by Arash on 7/13/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = l10n("about_us")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = true
        guard let path = Bundle.main.path(forResource: "about_us-fa", ofType: "html") else {
            fatalError("About us html is missing from bundle")
        }
        let url = URL(fileURLWithPath: path)
        let req = URLRequest(url: url)
        webView.load(req)
        
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
}
