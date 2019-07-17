//
//  PodcastsViewController.swift
//  PersianBMS
//
//  Created by Arash on 7/13/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit

class PodcastsViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = l10n("podcasts")
        self.tabBarItem = UITabBarItem(title: l10n("podcasts"), image: #imageLiteral(resourceName: "podcast-24pt@3x.png"), tag: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
