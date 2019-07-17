//
//  ContactUsViewController.swift
//  PersianBMS
//
//  Created by Arash on 7/13/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController {
    
    enum ContactUsRows: Int {
        case email = 0
        case telephone = 1
        case telegram = 2
    }
    
    private var tableView: UITableView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = l10n("contact_us")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.pbmsBlack
        tableView.dataSource = self
        tableView.delegate = self
        
        view = tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension ContactUsViewController: UITableViewDataSource {
    func subtitleCell(_ tableView: UITableView) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "subtitle-cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle-cell")
            cell?.backgroundColor = UIColor.pbmsGray
            cell?.textLabel?.textColor = UIColor.white
            cell?.detailTextLabel?.textColor = UIColor.white
        }
        return cell!
    }
    
    func regularCell(_ tableView: UITableView) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.backgroundColor = UIColor.pbmsGray
            cell?.textLabel?.textColor = UIColor.white
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = ContactUsRows(rawValue: indexPath.row) else {
            fatalError("\(indexPath.row) is not a known row")
        }
        
        var cell: UITableViewCell!
        
        switch row {
        case .email:
            cell = subtitleCell(tableView)
            cell.textLabel?.text = l10n("email_us")
            cell.detailTextLabel?.text = "info@persianbms.org"
            cell.imageView?.image = #imageLiteral(resourceName: "baseline_email_white_24pt")
        case .telephone:
            cell = subtitleCell(tableView)
            cell.textLabel?.text = l10n("call_us")
            cell.detailTextLabel?.text = "+1-703-671-8888"
            cell.imageView?.image = #imageLiteral(resourceName: "baseline_call_white_24pt")
        case .telegram:
            cell = regularCell(tableView)
            cell.textLabel?.text = l10n("telegram")
            cell.imageView?.image = #imageLiteral(resourceName: "icTelegram29Pt")
        }
        
        return cell
    }
    
    
}

extension ContactUsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = ContactUsRows(rawValue: indexPath.row) else {
            fatalError("\(indexPath.row) is not a known row")
        }
        
        switch row {
        case .email:
            if MFMailComposeViewController.canSendMail() {
                let mcvc = MFMailComposeViewController()
                mcvc.mailComposeDelegate = self
                mcvc.setToRecipients(["info@persianbms.org"])
                present(mcvc, animated: true, completion: nil)
            }
        case .telephone:
            let dialUrl = URL(string: "tel:+17036718888")!
            UIApplication.shared.open(dialUrl, options: [:], completionHandler: nil)
        case .telegram:
            SocialNetworks.open(.telegram)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
