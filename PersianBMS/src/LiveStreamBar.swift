//
//  LiveStreamBar.swift
//  PersianBMS
//
//  Created by Arash on 7/12/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit
import MediaPlayer

class LiveStreamBar: UIView {
    
    
    private let airplay: MPVolumeView
    private let artwork: UIImageView
    private let bgGradient: CAGradientLayer
    private let manager: LiveStreamManager
    private let togglePlayback: UIButton
    private let streamLabel: UILabel
    
    
    init(_ mgr: LiveStreamManager) {
        manager = mgr
        
        bgGradient = CAGradientLayer()
        bgGradient.colors = [UIColor(white: 0.2, alpha: 1).cgColor, UIColor.black.cgColor]
        bgGradient.startPoint = CGPoint(x: 0, y: 0)
        bgGradient.endPoint = CGPoint(x: 1, y: 1)
        
        artwork = UIImageView(image: #imageLiteral(resourceName: "pbms-logo-transparent-102w.png"))
        artwork.layer.cornerRadius = 4.0
        artwork.layer.masksToBounds = true
        artwork.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        artwork.translatesAutoresizingMaskIntoConstraints = false
        
        togglePlayback = UIButton(type: .system)
        togglePlayback.translatesAutoresizingMaskIntoConstraints = false
        togglePlayback.setImage(#imageLiteral(resourceName: "baseline_play_circle_filled_white_white_48pt").withRenderingMode(.alwaysOriginal), for: .normal)
        togglePlayback.layer.shadowColor = UIColor.black.cgColor
        togglePlayback.layer.shadowOffset = CGSize(width: 0, height: 4)
        togglePlayback.layer.shadowRadius = 0
        togglePlayback.layer.shadowOpacity = 1.0
        togglePlayback.sizeToFit()
        
        streamLabel = UILabel(frame: .zero)
        streamLabel.translatesAutoresizingMaskIntoConstraints = false
        streamLabel.text = l10n("live_stream")
        streamLabel.textColor = UIColor.white
        streamLabel.sizeToFit()
        
        airplay = MPVolumeView(frame: .zero)
        airplay.translatesAutoresizingMaskIntoConstraints = false
        airplay.showsVolumeSlider = false
        airplay.sizeToFit()
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.insertSublayer(bgGradient, at: 0)
        addSubview(artwork)
        addSubview(togglePlayback)
        addSubview(airplay)
        addSubview(streamLabel)
        manager.addListener(self)
        if manager.isPlaying {
            setPauseImage()
        } else {
            setPlayImage()
        }
//        togglePlayback.isHighlighted = manager.isPlaying
        
        togglePlayback.addTarget(self, action: #selector(onToggle), for: .touchUpInside)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgGradient.frame = bounds
    }
    
    @objc private func onToggle() {
        manager.togglePlayback()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            artwork.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            artwork.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            artwork.widthAnchor.constraint(equalToConstant: 44),
            artwork.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        NSLayoutConstraint.activate([
            togglePlayback.leadingAnchor.constraint(equalTo: self.artwork.trailingAnchor, constant: 8),
            togglePlayback.centerYAnchor.constraint(equalTo: self.artwork.centerYAnchor),
            togglePlayback.widthAnchor.constraint(equalToConstant: togglePlayback.bounds.size.width),
            togglePlayback.heightAnchor.constraint(equalToConstant: togglePlayback.bounds.size.height),
        ])
        
        NSLayoutConstraint.activate([
            streamLabel.leadingAnchor.constraint(equalTo: togglePlayback.trailingAnchor, constant: 16),
            streamLabel.centerYAnchor.constraint(equalTo: artwork.centerYAnchor),
            streamLabel.widthAnchor.constraint(equalToConstant: streamLabel.bounds.size.width),
        ])
        
        NSLayoutConstraint.activate([
            airplay.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            airplay.centerYAnchor.constraint(equalTo: artwork.centerYAnchor),
            airplay.widthAnchor.constraint(equalToConstant: airplay.bounds.width),
            airplay.heightAnchor.constraint(equalToConstant: airplay.bounds.height),
        ])
    }
    
    private func setPauseImage() {
        togglePlayback.setImage(#imageLiteral(resourceName: "sharp_pause_circle_filled_white_48pt").withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func setPlayImage() {
        togglePlayback.setImage(#imageLiteral(resourceName: "baseline_play_circle_filled_white_white_48pt").withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    deinit {
        manager.removeListener(self)
    }
    
}

extension LiveStreamBar: LiveStreamListener {
    func onLiveStreamPaused() {
        setPlayImage()
    }
    
    func onLiveStreamPlaying() {
        setPauseImage()
    }
}
