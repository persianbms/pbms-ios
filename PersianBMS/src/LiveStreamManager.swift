//
//  LiveStreamBar.swift
//  PersianBMS
//
//  Created by Arash on 7/12/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import AVFoundation
import MediaPlayer

protocol LiveStreamListener: class {
    func onLiveStreamPlaying()
    func onLiveStreamPaused()
}

class LiveStreamManager {
    
    static let shared = LiveStreamManager()
    
    var isPlaying: Bool {
        return player.rate == 1.0
    }
    private let player: AVPlayer
    private var listeners = [LiveStreamListener]()
    
    init() {
        player = AVPlayer(url: URL(string: "https://milkyway.tangledwires.io/stream.m3u8")!)
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
            self.notifyPaused()
            return .success
        }
        
        cmdCntr.playCommand.addTarget { (evt) -> MPRemoteCommandHandlerStatus in
            if self.player.rate == 0.0 {
                self.player.play()
                self.notifyPlaying()
                return .success
            }
            
            return .commandFailed
        }
        
        cmdCntr.togglePlayPauseCommand.addTarget { (evt) -> MPRemoteCommandHandlerStatus in
            if self.player.rate == 1.0 {
                self.player.pause()
                self.notifyPaused()
            } else {
                self.player.play()
                self.notifyPlaying()
            }
            
            return .success
        }
        
        cmdCntr.pauseCommand.addTarget { (evt) -> MPRemoteCommandHandlerStatus in
            if self.player.rate == 1.0 {
                self.player.pause()
                self.notifyPaused()
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
        notifyPlaying()
    }
    
    private func pause() {
        player.pause()
        notifyPaused()
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: [])
        } catch {
            NSLog("Failed to activate audio session: \(error.localizedDescription)")
        }
    }
    
    @objc public func togglePlayback() {
        if player.rate == 1.0 {
            pause()
        } else {
            play()
        }
    }
    
    // MARK: Listener management
    
    public func addListener(_ l: LiveStreamListener) {
        listeners.append(l)
    }
    
    private func notifyPlaying() {
        onMain {
            for l in self.listeners {
                l.onLiveStreamPlaying()
            }
        }
    }
    
    private func notifyPaused() {
        onMain {
            for l in self.listeners {
                l.onLiveStreamPaused()
            }
        }
    }
    
    public func removeListener(_ l: LiveStreamListener) {
        listeners = listeners.filter({ (iter) -> Bool in
            return iter === l
        })
    }
    
}
