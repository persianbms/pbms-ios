//
//  AboutController.swift
//  PersianBMS
//
//  Created by Arash on 7/2/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    enum AboutSections: Int {
        case aboutAndContact = 0
        case satelliteInfo = 1
        case socialNetworks = 2
    }
    
    private var tableView: UITableView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = l10n("about")
        self.tabBarItem = UITabBarItem(title: l10n("about"), image: #imageLiteral(resourceName: "outline_info_black_24pt"), tag: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let aboutView = AboutView()
        aboutView.tableView.dataSource = self
        aboutView.tableView.delegate = self
        aboutView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
//        tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.backgroundColor = UIColor.pbmsBlack
//        tableView.dataSource = self
//        tableView.delegate = self
//        let header = AboutTableHeaderView()
//        let hdrSize = header.preferredSize()
//        header.bounds = CGRect(x: 0, y: 0, width: hdrSize.width, height: hdrSize.height)
//        tableView.tableHeaderView = header
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view = aboutView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension AboutViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = AboutSections(rawValue: section) else {
            fatalError("\(section) is not a known section")
        }
        switch sec {
        case .aboutAndContact:
            return 2
        case .satelliteInfo:
            return 1
        case .socialNetworks:
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = AboutSections(rawValue: indexPath.section) else {
            fatalError("\(indexPath.section) is not a known section")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = nil
        cell.backgroundColor = UIColor.pbmsGray
        cell.textLabel?.textColor = UIColor.white
        
        switch section {
        case .aboutAndContact:
            configureAboutAndContactRow(cell, indexPath.row)
        case .satelliteInfo:
            configureSatelliteInfoRow(cell)
        case .socialNetworks:
            configureSocialNetworkRow(cell, indexPath.row)
        }
        
        return cell
    }
    
    func configureAboutAndContactRow(_ cell: UITableViewCell, _ row: Int) {
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "row \(row)"
        if row == 0 {
            cell.textLabel?.text = l10n("about_us")
        } else if row == 1 {
            cell.textLabel?.text = l10n("contact_us")
        }
    }
    
    func configureSatelliteInfoRow(_ cell: UITableViewCell) {
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = l10n("satellite_broadcast_information")
    }
    
    func configureSocialNetworkRow(_ cell: UITableViewCell, _ row: Int) {
        cell.accessoryType = .none
        cell.textLabel?.text = "social network \(row)"
        
        guard let network = SocialNetwork(rawValue: row) else {
            fatalError("\(row) is not a known social network row")
        }
        switch network {
        case .telegram:
            cell.textLabel?.text = l10n("telegram")
            cell.imageView?.image = #imageLiteral(resourceName: "icTelegram29Pt")
        case .instagram:
            cell.textLabel?.text = l10n("instagram")
            cell.imageView?.image = #imageLiteral(resourceName: "ic_instagram_24_dp")
        case .facebook:
            cell.textLabel?.text = l10n("facebook")
            cell.imageView?.image = #imageLiteral(resourceName: "icFacebook29Pt")
        case .youtube:
            cell.textLabel?.text = l10n("youtube")
            cell.imageView?.image = #imageLiteral(resourceName: "icYoutube29Pt")
        case .soundcloud:
            cell.textLabel?.text = l10n("soundcloud")
            cell.imageView?.image = #imageLiteral(resourceName: "icSoundcloud29Pt")
        case .twitter:
            cell.textLabel?.text = l10n("twitter")
            cell.imageView?.image = #imageLiteral(resourceName: "icTwitter29Pt")
        }
        
        cell.imageView?.bounds = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
}

extension AboutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sec = AboutSections(rawValue: section) else {
            fatalError("\(section) is not a known section")
        }
        
        if sec == .socialNetworks {
            return l10n("follow_us")
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = AboutSections(rawValue: indexPath.section) else {
            fatalError("\(indexPath.section) is not a known section")
        }
        
        switch section {
        case .aboutAndContact:
            if indexPath.row == 0 {
                let auvc = AboutUsViewController()
                navigationController?.pushViewController(auvc, animated: true)
            } else if indexPath.row == 1 {
                let cuvc = ContactUsViewController()
                navigationController?.pushViewController(cuvc, animated: true)
            }
        case .satelliteInfo:
            let sivc = SatelliteInfoViewController()
            navigationController?.pushViewController(sivc, animated: true)
        case .socialNetworks:
            guard let network = SocialNetwork(rawValue: indexPath.row) else {
                fatalError("\(indexPath.row) is an unknown social network row")
            }
            SocialNetworks.open(network)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
