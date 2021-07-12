//
//  PlayerViewController.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import UIKit
import AVKit

private let kAdvertUrl = "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8".toUrl

class PlayerViewController: AVPlayerViewController {
    var asset: AssetModel?
    var rail: RailModel?
    var url: URL?
    var initialized: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !initialized {
            if asset != nil {
                startAssetPlayback()
            } else {
                startAdvertPlayback()
            }
        }
        initialized = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    
    private func setupPlayer() {
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(playbackFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func startAssetPlayback() {
        switch asset?.type {
        case .movie:
            if let url = asset?.url.toUrl {
                let playerItem = createPlayerItem(url: url)
                player = AVPlayer(playerItem: playerItem)
            }
        case .series:
            var playerItems: [AVPlayerItem] = []
            if let rail = rail?.list {
                for item in rail {
                    if let url = item.url.toUrl {
                        let playerItem = createPlayerItem(url: url)
                        if item.id == asset?.id {
                            playerItems.insert(playerItem, at: 0)
                        } else {
                            playerItems.append(playerItem)
                        }
                    }
                }
            }
            player = AVQueuePlayer(items: playerItems)
        case .none: break
        }
        player?.play()
    }
    
    private func startAdvertPlayback() {
        if let url = url {
            player = AVPlayer(url: url)
            player?.play()
        }
    }
    
    private func createPlayerItem(url: URL) -> AVPlayerItem {
        let playerItem = AVPlayerItem(url: url)
        // Add advertisement timerange
        var timeRanges: [AVInterstitialTimeRange] = []
        for index in stride(from: 60, to: 600, by: 60) {
            let range = AVInterstitialTimeRange(timeRange: CMTimeRange(start: CMTime(seconds: Double(index), preferredTimescale: .max), duration: CMTime(seconds: 1, preferredTimescale: .max)))
            timeRanges.append(range)
        }
        playerItem.interstitialTimeRanges = timeRanges
        return playerItem
    }
    
    @objc private func playbackFinished() {
        if let queuePlayer = player as? AVQueuePlayer {
            if queuePlayer.currentItem != queuePlayer.items().last {
                return
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController: AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController, willPresent interstitial: AVInterstitialTimeRange) {
        let playerVC = PlayerViewController()
        playerVC.url = kAdvertUrl
        present(playerVC, animated: false, completion: nil)
    }
}
