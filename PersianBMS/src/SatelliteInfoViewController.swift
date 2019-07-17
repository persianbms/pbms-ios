//
//  SatelliteInfoViewController.swift
//  PersianBMS
//
//  Created by Arash on 7/13/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit

class SatelliteInfoViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = l10n("satellite_info")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SatelliteInfoView()
    }
    
    override func viewDidLoad() {
        edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
