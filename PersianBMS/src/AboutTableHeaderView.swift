//
//  AboutTableHeaderView.swift
//  PersianBMS
//
//  Created by Arash on 7/3/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit

class AboutTableHeaderView: UIView {
    
    private let logo: UIImageView
    private let subtitle: UITextField
    
    init() {
        logo = UIImageView(image: #imageLiteral(resourceName: "pbms-logo-transparent-102w.png"))

        subtitle = UITextField(frame: .zero)
        subtitle.text = l10n("persianbms")
        subtitle.sizeToFit()
        subtitle.textAlignment = .center
        subtitle.textColor = UIColor.white
        
        super.init(frame: .zero)
        
        backgroundColor = UIColor.pbmsGray
        addSubview(logo)
        addSubview(subtitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imgSize: CGFloat = 44.0
        logo.bounds = CGRect(x: 0, y: 0, width: imgSize, height: imgSize)
        logo.center = CGPoint(x: bounds.width/2.0, y: 16 + imgSize/2.0)
        
        subtitle.sizeToFit()
        subtitle.center = CGPoint(x: bounds.width/2.0,
                                  y: logo.frame.maxY + 8 + subtitle.bounds.height/2.0)
    }
    
    func preferredSize() -> CGSize {
        layoutSubviews()
        return CGSize(width: UIScreen.main.bounds.width, height: subtitle.frame.maxY+16)
    }
}
