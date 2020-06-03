//
//  VideoListViewCell.swift
//  YTPlayer-Test
//
//  Created by Sivda on 1/6/2020.
//

import UIKit
import YoutubeKit

class VideoListViewCell: UICollectionViewCell {
  static let reuseIdentifier = "VideoListViewCell"
  
  let playerView: YTSwiftyPlayer
  private(set) var videoId: String?
  
  override init(frame: CGRect) {
    playerView = YTSwiftyPlayer()
    playerView.autoplay = true

    super.init(frame: frame)
    
    backgroundColor = .systemGray
    playerView.frame = contentView.bounds
    playerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    playerView.delegate = self
    contentView.addSubview(playerView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func loadPlayerWithVideoId(_ videoId: String) {
    self.videoId = videoId
    playerView.setPlayerParameters([
      .playsInline(true),
      .videoID(videoId)
    ])
    
    playerView.loadPlayer()
  }
}

extension VideoListViewCell: YTSwiftyPlayerDelegate {
  func playerReady(_ player: YTSwiftyPlayer) {
    player.mute()
  }
}
