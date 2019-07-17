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
    let headerView: AboutTableHeaderView
    let tableView: UITableView
    
    init() {
        liveStreamBar = LiveStreamBar(LiveStreamManager.shared)
        liveStreamBar.translatesAutoresizingMaskIntoConstraints = false
        
        headerView = AboutTableHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.pbmsBlack
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: .zero)
        self.backgroundColor = UIColor.pbmsBlack
        
        addSubview(liveStreamBar)
        addSubview(headerView)
        addSubview(tableView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        var lsbTop: NSLayoutYAxisAnchor = self.topAnchor
        if #available(iOS 11.0, *) {
            lsbTop = safeAreaLayoutGuide.topAnchor
        }
        
        NSLayoutConstraint.activate([
            liveStreamBar.topAnchor.constraint(equalTo: lsbTop),
            liveStreamBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            liveStreamBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            liveStreamBar.heightAnchor.constraint(equalToConstant: 64),
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: liveStreamBar.bottomAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 105),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        var safeTop: CGFloat = 0
//        if #available(iOS 11.0, *) {
//            safeTop = safeAreaInsets.top
//        }
//
//        liveStreamBar.frame = CGRect(x: 0,
//                                     y: safeTop,
//                                     width: bounds.width,
//                                     height: 64)
//
//        let hdrView = tableView.tableHeaderView as! AboutTableHeaderView
//        let size = hdrView.preferredSize()
//        hdrView.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        tableView.frame = CGRect(x: 0,
//                                 y: liveStreamBar.frame.maxY,
//                                 width: bounds.width,
//                                 height: bounds.height - liveStreamBar.frame.maxY)
//    }
    
}
