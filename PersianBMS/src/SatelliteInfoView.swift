//
//  SatelliteInfoView.swift
//  PersianBMS
//
//  Created by Arash on 7/13/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit

class SatelliteInfoView: UIView {
    
    private let section1Title = UILabel(frame: .zero)
    private let section2Title = UILabel(frame: .zero)
    private var allViews = [UIView]()
    private let bodyView: SatelliteSectionBodyView
    
    init() {
        section1Title.textColor = UIColor.pbmsLightBlue
        section1Title.text = "Section 1"
        section1Title.sizeToFit()
        
        section2Title.textColor = UIColor.pbmsLightBlue
        section2Title.text = "Section 2"
        section2Title.sizeToFit()
        
        bodyView = SatelliteSectionBodyView()
        
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.pbmsBlack
        
        allViews = [
            section1Title,
            section2Title,
        ]
//        addSubview(section1Title)
//        addSubview(section2Title)
        addSubview(bodyView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bodyView.frame = bounds
        
//        var yStart: CGFloat = 0
//        for v in allViews {
//            v.frame = CGRect(x: 0, y: yStart, width: bounds.width, height: v.bounds.size.height)
//            yStart += v.bounds.size.height
//        }
    }
}
