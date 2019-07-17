//
//  SatelliteSectionBodyView.swift
//  PersianBMS
//
//  Created by Arash on 7/16/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit

class SatelliteSectionBodyView: UIView {
    
    let title: UILabel
    let content: UILabel
    
    init() {
        title = UILabel(frame: .zero)
        title.numberOfLines = 0
        title.textColor = UIColor.white
//        title.text = "nothing can\never hurt me\nnow"
        title.text = "سلام دنیا"
        title.backgroundColor = UIColor.red
        title.textAlignment = .natural
        title.translatesAutoresizingMaskIntoConstraints = false
        
        content = UILabel(frame: .zero)
        content.numberOfLines = 0
        content.textColor = UIColor.white
        content.backgroundColor = UIColor.green
        content.text = "سلام دنیا"
        content.textAlignment = .natural
//        content.text = """
//Satellite: Hotbird 13D - 13' East
//D/L Frequency: 11,200 MHz
//D/L Polarity: Vertical
//"""
        content.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: .zero)
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.pbmsGray.cgColor
        
        addSubview(title)
        addSubview(content)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
        ])
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            content.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
        ])
    }
}
