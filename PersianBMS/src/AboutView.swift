//
//  AboutView.swift
//  PersianBMS
//
//  Created by Arash on 7/14/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit

class AboutView: UIView {
    
    let liveStreamBar: LiveStreamBar
    let tableView: UITableView
    
    init() {
        liveStreamBar = LiveStreamBar(LiveStreamManager.shared)
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.pbmsBlack
        let header = AboutTableHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        let hdrSize = header.preferredSize()
        header.bounds = CGRect(x: 0, y: 0, width: hdrSize.width, height: hdrSize.height)
        header.layoutSubviews()
        tableView.tableHeaderView = header
        
        super.init(frame: .zero)
        
        addSubview(liveStreamBar)
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var safeTop: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeTop = safeAreaInsets.top
        }

        liveStreamBar.frame = CGRect(x: 0,
                                     y: safeTop,
                                     width: bounds.width,
                                     height: 64)
        
        let hdrView = tableView.tableHeaderView as! AboutTableHeaderView
        let size = hdrView.preferredSize()
        hdrView.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        tableView.frame = CGRect(x: 0,
                                 y: liveStreamBar.frame.maxY,
                                 width: bounds.width,
                                 height: bounds.height - liveStreamBar.frame.maxY)
    }
    
}
