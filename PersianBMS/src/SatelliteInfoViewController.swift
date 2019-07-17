//
//  SatelliteInfoViewController.swift
//  PersianBMS
//
//  Created by Arash on 7/13/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit

class SatelliteInfoTitleCell: UICollectionViewCell {
    let title: UILabel
    
    override init(frame: CGRect) {
        title = UILabel(frame: .zero)
        title.textColor = UIColor.pbmsLightBlue
        title.font = UIFont.systemFont(ofSize: 20)
        title.textAlignment = .natural
        title.numberOfLines = 0
        
        super.init(frame: frame)
        
        contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        title.sizeToFit()
        title.frame = CGRect(x: 16, y: 8, width: bounds.width - 32, height: title.bounds.size.height)
    }
    
    func size() -> CGSize {
        layoutSubviews()
        return CGSize(width: UIScreen.main.bounds.width, height: title.frame.maxY + 8)
    }
}

class SatelliteInfoBodyCell: UICollectionViewCell {
    
    let border: UIView
    let title: UILabel
    let body: UILabel
    
    override init(frame: CGRect) {
        border = UIView(frame: .zero)
        border.backgroundColor = UIColor.pbmsBlack
        border.layer.borderColor = UIColor.pbmsGray.cgColor
        border.layer.borderWidth = 1
        
        title = UILabel(frame: .zero)
        title.textColor = UIColor.white
        title.textAlignment = .natural
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 20)
        
        body = UILabel(frame: .zero)
        body.textColor = UIColor.white
        body.textAlignment = .natural
        body.numberOfLines = 0
        body.font = UIFont.systemFont(ofSize: 16)
        
        super.init(frame: frame)
        
        addSubview(border)
        addSubview(title)
        addSubview(body)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        title.sizeToFit()
        title.frame = CGRect(x: 32, y: 16, width: bounds.width - 64, height: title.bounds.height)
        
        let size = body.sizeThatFits(CGSize(width: UIScreen.main.bounds.width-48, height: 500))
        body.frame = CGRect(x: 32, y: title.frame.maxY + 8, width: UIScreen.main.bounds.width-64, height: size.height)
        
        border.frame = CGRect(x: 16, y: 0, width: bounds.width - 32, height: body.frame.maxY + 16)
    }
    
    func size() -> CGSize {
        layoutSubviews()
        return CGSize(width: UIScreen.main.bounds.width, height: border.frame.maxY)
    }
}

class SatelliteInfoViewController: UIViewController {
    
    enum SatelliteInfoRow: Int {
        case radioBroadcastTitle = 0
        case radioIranEurope = 1
        case radioNorthAmerica = 2
        case tvBroadcastTitle = 3
        case tvNoveen = 4
        case tvAinBahai = 5
    }
    
    private var collectionView: UICollectionView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.title = l10n("satellite_info")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 16)
        layout.minimumLineSpacing = 16
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SatelliteInfoTitleCell.self, forCellWithReuseIdentifier: "title")
        collectionView.register(SatelliteInfoBodyCell.self, forCellWithReuseIdentifier: "body")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.pbmsBlack
        
        view = collectionView
    }
    
    override func viewDidLoad() {
        edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func configureTitleCell(_ cell: SatelliteInfoBodyCell, _ row: SatelliteInfoRow) {
        
    }
    
    private func configureCell(_ cell: UICollectionViewCell, _ row: SatelliteInfoRow) {
        switch row {
        case .radioBroadcastTitle:
            let titleCell = cell as! SatelliteInfoTitleCell
            titleCell.title.text = l10n("radio_broadcast_24_hours_msg")
        case .radioIranEurope:
            let bodyCell = cell as! SatelliteInfoBodyCell
            bodyCell.title.text = l10n("iran_and_europe")
            bodyCell.body.text = """
Satellite: Hotbird 13D - 13° east
D/L frequency: 11,200 MHz
D/L polarity: Vertical
Transponder: 134
Symbol rate: 27,500
FEC: 5/6
"""
        case .radioNorthAmerica:
            let bodyCell = cell as! SatelliteInfoBodyCell
            bodyCell.title.text = l10n("north_america")
            bodyCell.body.text = """
Satellite Galaxy 19 - 97° west
D/L frequency: 12,152 MHz
D/L polarity: Horizontal
Transponder: 26
Symbol rate: 20,000
FEC: 3/4
"""
        case .tvBroadcastTitle:
            let titleCell = cell as! SatelliteInfoTitleCell
            titleCell.title.text = l10n("tv_schedule")
        case .tvNoveen:
            let bodyCell = cell as! SatelliteInfoBodyCell
            bodyCell.title.text = l10n("noveen_tv")
            bodyCell.body.text = l10n("noveen_tv_schedule_msg")
        case .tvAinBahai:
            let bodyCell = cell as! SatelliteInfoBodyCell
            bodyCell.title.text = l10n("ain_bahai_tv")
            bodyCell.body.text = l10n("ain_bahai_tv_schedule_msg")
        }
    }
}

extension SatelliteInfoViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let row = SatelliteInfoRow(rawValue: indexPath.row) else {
            fatalError("\(indexPath.row) is not a known row")
        }
        
        switch row {
        case .radioBroadcastTitle:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath) as! SatelliteInfoTitleCell
            configureCell(cell, row)
            return cell
        case .radioIranEurope:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "body", for: indexPath) as! SatelliteInfoBodyCell
            configureCell(cell, row)
            return cell
        case .radioNorthAmerica:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "body", for: indexPath) as! SatelliteInfoBodyCell
            configureCell(cell, row)
            return cell
        case .tvBroadcastTitle:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath) as! SatelliteInfoTitleCell
            configureCell(cell, row)
            return cell
        case .tvNoveen:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "body", for: indexPath) as! SatelliteInfoBodyCell
            configureCell(cell, row)
            return cell
        case .tvAinBahai:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "body", for: indexPath) as! SatelliteInfoBodyCell
            configureCell(cell, row)
            return cell
        }
    }
}

extension SatelliteInfoViewController: UICollectionViewDelegate {
    
}

extension SatelliteInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let row = SatelliteInfoRow(rawValue: indexPath.row) else {
            fatalError("\(indexPath.row) is not a known row")
        }

        if row == .radioBroadcastTitle || row == .tvBroadcastTitle {
            let cell = SatelliteInfoTitleCell(frame: .zero)
            configureCell(cell, row)
            return cell.size()
        }
        
        let cell = SatelliteInfoBodyCell(frame: .zero)
        configureCell(cell, row)
        return cell.size()
    }
}
