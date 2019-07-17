//
//  LiveStreamViewController.swift
//  PersianBMS
//
//  Created by Arash on 7/2/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class LiveStreamViewController: UIViewController {
    
    private var liveStreamView: LiveStreamView!
    private var player: AVPlayer!
    
    init() {
        player = AVPlayer(url: URL(string: "https://milkyway.tangledwires.io/stream.m3u8")!)
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = l10n("live")
        self.tabBarItem = UITabBarItem(title: l10n("live"), image: #imageLiteral(resourceName: "outline_radio_black_24pt"), tag: 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        liveStreamView = LiveStreamView()
        liveStreamView.togglePlayback.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        view = liveStreamView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
    }
    
    @objc private func onAirplayAction() {
        
    }
    
    private func play() {
        let cmdCntr = MPRemoteCommandCenter.shared()
        cmdCntr.bookmarkCommand.isEnabled = false
        cmdCntr.nextTrackCommand.isEnabled = false
        cmdCntr.previousTrackCommand.isEnabled = false
        cmdCntr.changeRepeatModeCommand.isEnabled = false
        cmdCntr.changeShuffleModeCommand.isEnabled = false
        cmdCntr.changePlaybackRateCommand.isEnabled = false
        cmdCntr.seekBackwardCommand.isEnabled = false
        cmdCntr.seekForwardCommand.isEnabled = false
        cmdCntr.skipBackwardCommand.isEnabled = false
        cmdCntr.skipForwardCommand.isEnabled = false
        cmdCntr.changePlaybackPositionCommand.isEnabled = false
        cmdCntr.ratingCommand.isEnabled = false
        cmdCntr.likeCommand.isEnabled = false
        cmdCntr.dislikeCommand.isEnabled = false
        cmdCntr.enableLanguageOptionCommand.isEnabled = false
        cmdCntr.disableLanguageOptionCommand.isEnabled = false
        
        cmdCntr.stopCommand.addTarget { (evt) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.liveStreamView.togglePlayback.isSelected = false
            return .success
        }
        
        cmdCntr.playCommand.addTarget { (evt) -> MPRemoteCommandHandlerStatus in
            if self.player.rate == 0.0 {
                self.player.play()
                self.liveStreamView.togglePlayback.isSelected = true
                return .success
            }
            
            return .commandFailed
        }
        
        cmdCntr.togglePlayPauseCommand.addTarget { (evt) -> MPRemoteCommandHandlerStatus in
            if self.player.rate == 1.0 {
                self.player.pause()
                self.liveStreamView.togglePlayback.isSelected = false
            } else {
                self.player.play()
                self.liveStreamView.togglePlayback.isSelected = true
            }
            
            return .success
        }
        
        cmdCntr.pauseCommand.addTarget { (evt) -> MPRemoteCommandHandlerStatus in
            if self.player.rate == 1.0 {
                self.player.pause()
                self.liveStreamView.togglePlayback.isSelected = false
                return .success
            }
            return .commandFailed
        }
        
        var info  = [String:Any]()
        info[MPMediaItemPropertyTitle] = l10n("persianbms_radio")
        info[MPNowPlayingInfoPropertyAssetURL] = URL(string: "https://milkyway.tangledwires.io/stream.m3u8")!
        info[MPNowPlayingInfoPropertyExternalContentIdentifier] = "org.persianbahaimedia.live-stream"
        info[MPNowPlayingInfoPropertyIsLiveStream] = NSNumber(value: 1.0)
        info[MPNowPlayingInfoPropertyMediaType] = NSNumber(value: MPNowPlayingInfoMediaType.audio.rawValue)
        let streamArt = #imageLiteral(resourceName: "live-stream-artwork.png")
        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: streamArt.size, requestHandler: { (size) -> UIImage in
            return streamArt
        })
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            NSLog("Failed to deactivate audio session: \(error.localizedDescription)")
            return
        }
        player.play()
        self.liveStreamView.togglePlayback.isSelected = true
    }
    
    private func pause() {
        player.pause()
        self.liveStreamView.togglePlayback.isSelected = false
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: [])
        } catch {
            NSLog("Failed to activate audio session: \(error.localizedDescription)")
        }
    }
    
    @objc private func togglePlayback() {
        if player.rate == 1.0 {
            pause()
        } else {
            play()
        }
    }
}
