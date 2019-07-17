//
//  LiveStreamView.swift
//  PersianBMS
//
//  Created by Arash on 7/2/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit
import MediaPlayer

class LiveStreamView: UIView {
    
    let artwork: UIImageView
    let togglePlayback: UIButton
    let volumeView: MPVolumeView
    let bgGradient: CAGradientLayer
    
    init() {
        bgGradient = CAGradientLayer()
        bgGradient.colors = [UIColor(white: 0.2, alpha: 1).cgColor, UIColor.black.cgColor]
        bgGradient.startPoint = CGPoint(x: 0, y: 0)
        bgGradient.endPoint = CGPoint(x: 1, y: 1)
        
        artwork = UIImageView(image: #imageLiteral(resourceName: "live-stream-artwork.png"))
        artwork.translatesAutoresizingMaskIntoConstraints = false
        artwork.layer.cornerRadius = 8
        artwork.layer.masksToBounds = true
        
        togglePlayback = UIButton(type: .system)
        togglePlayback.translatesAutoresizingMaskIntoConstraints = false
        togglePlayback.setImage(#imageLiteral(resourceName: "play-button.png").withRenderingMode(.alwaysOriginal), for: .normal)
        togglePlayback.setImage(#imageLiteral(resourceName: "pause-button.png").withRenderingMode(.alwaysTemplate), for: .selected)
        togglePlayback.tintColor = UIColor.white
        togglePlayback.sizeToFit()
        
        volumeView = MPVolumeView(frame: .zero)
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        volumeView.showsVolumeSlider = false
        volumeView.sizeToFit()
        
        super.init(frame: .zero)
        
        layer.insertSublayer(bgGradient, at: 0)
        addSubview(artwork)
        addSubview(togglePlayback)
        addSubview(volumeView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgGradient.frame = bounds
    }
    
    private func setupConstraints() {
//        var safeArea: UIEdgeInsets = .zero
//        if #available(iOS 11.0, *) {
//            safeArea = safeAreaInsets
//        }
        NSLayoutConstraint.activate([
            artwork.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 48),
            artwork.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -32),
            artwork.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48),
            artwork.heightAnchor.constraint(equalTo: artwork.widthAnchor, multiplier: artwork.image!.size.height / artwork.image!.size.width)
        ])
        
        NSLayoutConstraint.activate([
            togglePlayback.widthAnchor.constraint(equalTo: artwork.widthAnchor, multiplier: 0.5),
            togglePlayback.heightAnchor.constraint(equalTo: togglePlayback.widthAnchor, multiplier: 1),
            togglePlayback.topAnchor.constraint(equalTo: artwork.bottomAnchor, constant: 32),
            togglePlayback.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 1)
        ])
        
        NSLayoutConstraint.activate([
            volumeView.topAnchor.constraint(equalTo: togglePlayback.bottomAnchor, constant: 48),
            volumeView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 1),
            volumeView.widthAnchor.constraint(equalTo: artwork.widthAnchor, multiplier: 1),
            volumeView.heightAnchor.constraint(equalToConstant: volumeView.bounds.height)
        ])
    }
    
}
