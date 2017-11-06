//
//  ViewController.swift
//  VideoCover
//
//  Created by KK Chen on 6/11/2017.
//  Copyright © 2017 bichenkk. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class ViewController: UIViewController {

    @IBOutlet var videoView: UIView!
    var introPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if introPlayer == nil {
            videoView.contentMode = .scaleAspectFill
            playVideo()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        introPlayer?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        introPlayer?.pause()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @objc func appDidBecomeActive() {
        introPlayer?.play()
    }
    
    func playVideo() {
        let path = Bundle.main.path(forResource: "introduction", ofType: "mp4")
        let url  = NSURL.fileURL(withPath: path!)
        introPlayer = AVPlayer(url: url)
        if let introPlayer = introPlayer {
            introPlayer.allowsExternalPlayback = false
            let introPlayerLayer = AVPlayerLayer(player: introPlayer)
            introPlayerLayer.videoGravity = .resizeAspectFill
            videoView.layer.addSublayer(introPlayerLayer)
            introPlayerLayer.frame = videoView.bounds
            introPlayer.rate = 2
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: introPlayer.currentItem)
        }
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero)
        }
        if let introPlayer = introPlayer {
            introPlayer.play()
        }
    }
    
}

