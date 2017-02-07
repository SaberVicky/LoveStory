//
//  LSVideoPlayerViewController.swift
//  LoveStory
//
//  Created by songlong on 2017/1/12.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit
import AVFoundation

class LSVideoPlayerViewController: UIViewController {

    var playerItem:AVPlayerItem!
    var avplayer:AVPlayer!
    var playerLayer:AVPlayerLayer!
    var videoUrl: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let playerView = ZZPlayerView(frame: UIScreen.main.bounds)
        view.addSubview(playerView)

        // Do any additional setup after loading the view.
        let url = URL(string: videoUrl)
        playerItem = AVPlayerItem(url: url!)
        avplayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: avplayer)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        
        playerView.playerLayer = playerLayer
        playerView.layer.insertSublayer(playerLayer, at: 0)
        
        avplayer.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}

class ZZPlayerView: UIView {
    var playerLayer:AVPlayerLayer?
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
