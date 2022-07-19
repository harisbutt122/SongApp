//
//  HomeViewController.swift
//  Global Hits Radio
//
//  Created by Macbook Pro on 06/04/2020.
//  Copyright © 2020 Muhammad Haris Butt. All rights reserved.


//

import Foundation
import UIKit
import SwiftEventBus
import Kingfisher
import MarqueeLabel
import AVFoundation
import MediaPlayer
import Async
import JGProgressHUD

class HomeViewController: UIViewController{
    
    @IBOutlet weak var playButton: UIButton?
    @IBOutlet weak var menuButton: UIButton?
    @IBOutlet weak var trackImageContainer: UIView?
    @IBOutlet weak var trackImage: UIImageView?
    @IBOutlet weak var trackName: MarqueeLabel?
    
    private var isFirstTime = true
    private var isPlaying = false
    private var player: AVPlayer?
    var nowPlayingInfo = [String : Any]()
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    private let hud = JGProgressHUD(style: .dark)
    private var lastRadioStatus : RadioStatus? = nil
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.protectedDataWillBecomeUnavailableNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
                                               object: nil)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        setupAudioSession()
        trackImage?.isHidden = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshView),
                                               name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                               object: player)
        SwiftEventBus.onMainThread(self, name: "ApplicationDidEnterBackground") { result in
            self.pauseLivestream()
        }
        self.updateMetaDataEvent()
        initializeStreamingPlayer()
        setupRemoteCommandCenter()
        
    }
    func pollServerRequestForUpdatedMetaData(){
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.updateMetaDataEvent()
        }
    }
    
    func updateMetaDataEvent(){
        SwiftEventBus.onMainThread(self, name:"updateMetaData") { result in
            self.lastRadioStatus = result?.object as? RadioStatus
            self.trackName?.text = self.lastRadioStatus?.trackTitle
            let url = URL(string: self.lastRadioStatus?.artworkLargeUrl ?? "")
            
            self.trackImage?.kf.setImage(with: url,
                                         placeholder: nil,
                                         options: nil,
                                         progressBlock: { (_, _) in
                
            }, completionHandler: { (image, error, _, _) in
                self.hud.dismiss()
                self.trackImage?.alpha = 0
                UIView.animate(withDuration: 0.5, animations: { self.trackImage?.alpha = 1 })
                debugPrint("Downloaded and set!")
                //Auto-play
                if(self.isFirstTime){
                    self.trackImage?.isHidden = false
                    self.isFirstTime = false
                    self.playLivestream(artworkImage: (self.trackImage?.image!)!)
                    
                }
                Async.main({
                    self.setupNowPlaying(title: self.lastRadioStatus?.trackTitle ?? "", image: self.trackImage?.image ?? UIImage())
                })
            })
            
        }
    }
    
    @objc func refreshView(){
        print("data Changes")
    }
    
    @objc func applicationDidBecomeActive() {
        print("data Changes")
        self.pollServerRequestForUpdatedMetaData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        trackImage?.setRounded()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(self.player?.isPlaying ?? false){
            self.isPlaying = true
            self.playButton?.setImage(R.image.pause_icon(), for: .normal)
        } else {
            self.isPlaying = false
            self.playButton?.setImage(R.image.play_icon(), for: .normal)
        }
    }
    
    func initializeStreamingPlayer(){
        let urlString = "https://stream.radio.co/sef292cd6f/listen"
        guard let url = URL.init(string: urlString)
        else {
            return
        }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        
    }
    
    func setupNowPlaying(title : String, image: UIImage) {
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Global Radio"
        nowPlayingInfo[MPMediaItemPropertyArtist] = title
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        Async.main({
            let image =  image
            let artwork = MPMediaItemArtwork.init(boundsSize: image.size, requestHandler: { (size) -> UIImage in
                return image
            })
            self.nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        })
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
    
    func setupAudioSession() {
        do {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: [])
            try! AVAudioSession.sharedInstance().setCategory(.playback)
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
            if #available(iOS 10.0, *) {
                try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            }
            else {
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            debugPrint("Error setting the AVAudioSession:", error.localizedDescription)
        }
    }
    
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            self.playLivestream(artworkImage: (self.trackImage?.image!)!)
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            self.pauseLivestream()
            
            return .success
        }
    }
    
    @IBAction func menuButtonPressed(sender: UIButton) {
        guard let menuOptionsVC = R.storyboard.main.shareOptionsViewController() else { return  }
        menuOptionsVC.dataSource = self.lastRadioStatus?.songsHistory
        self.present(menuOptionsVC, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        shareAcitvity()
    }
    
    @IBAction func playButtonPressed(sender: UIButton) {
        Async.main({
            if(self.player != nil) {
                if(!self.isPlaying){
                    self.isPlaying = true
                    self.playButton?.setImage(R.image.pause_icon(), for: .normal)
                    self.player?.play()
                    self.setupNowPlaying(title: self.trackName?.text ?? "", image: (self.trackImage?.image!)!)
                } else {
                    self.isPlaying = false
                    self.playButton?.setImage(R.image.play_icon(), for: .normal)
                    self.player?.pause()
                    MPNowPlayingInfoCenter.default().playbackState = .paused
                }
            }
        })
    }
    
    private func playLivestream(artworkImage : UIImage){
        if(!self.isPlaying){
            self.isPlaying = true
            self.playButton?.setImage(R.image.pause_icon(), for: .normal)
            self.player?.play()
            self.setupNowPlaying(title: self.trackName?.text ?? "", image: artworkImage)
        }
    }
    
    private func pauseLivestream(){
        if(self.isPlaying){
            self.isPlaying = false
            self.playButton?.setImage(R.image.play_icon(), for: .normal)
            self.player?.pause()
            MPNowPlayingInfoCenter.default().playbackState = .paused
        }
    }
    
    private func shareAcitvity(){
        let myWebsite = NSURL(string:"https://globalhitsradio.com/")
        let shareAll = [ myWebsite]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    deinit {
        SwiftEventBus.unregister(self)
    }
}
