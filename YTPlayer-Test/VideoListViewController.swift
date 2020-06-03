//
//  VideoListViewController.swift
//  YTPlayer-Test
//
//  Created by Sivda on 1/6/2020.
//

import UIKit

protocol VideoListViewControllerDelegate: class {
  func controller(_ controller: VideoListViewController, willDisplay cell: VideoListViewCell, forItemAt indexPath: IndexPath)
  func controller(_ controller: VideoListViewController, didEndDisplaying cell: VideoListViewCell, forItemAt indexPath: IndexPath)
}

class VideoListViewController: UIViewController {
  enum CellType {
    case normal
    case video(id: String)
  }
  
  private static let normalCellReuseIdentifier = "normal-cell"
  private let cellTypes: [CellType]
  
  var collectionView: UICollectionView!
  weak var delegate: VideoListViewControllerDelegate?
  
  init(cellTypes: [CellType]) {
    self.cellTypes = cellTypes
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    view.backgroundColor = .groupTableViewBackground
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 8
    layout.sectionInset = .zero
    
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.register(VideoListViewCell.self, forCellWithReuseIdentifier: VideoListViewCell.reuseIdentifier)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: VideoListViewController.normalCellReuseIdentifier)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: collectionView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: collectionView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: collectionView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: collectionView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
    ])
  }
}

// MARK: - UICollectionViewDataSource

extension VideoListViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellTypes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellType = cellTypes[indexPath.item]
    switch cellType {
    case .normal:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoListViewController.normalCellReuseIdentifier, for: indexPath)
      cell.backgroundColor = .white
      return cell
    case .video:
      return collectionView.dequeueReusableCell(withReuseIdentifier: VideoListViewCell.reuseIdentifier, for: indexPath)
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension VideoListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
    let widthToHeightRatio: CGFloat = 9.0 / 16.0
    return CGSize(width: maxWidth, height: maxWidth * widthToHeightRatio)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? VideoListViewCell, case let .video(id: videoId) = cellTypes[indexPath.item] {
      if cell.videoId == videoId {
        cell.playerView.playVideo()
      } else {
        cell.loadPlayerWithVideoId(videoId)
      }
      
      delegate?.controller(self, willDisplay: cell, forItemAt: indexPath)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? VideoListViewCell {
      cell.playerView.pauseVideo()

      delegate?.controller(self, didEndDisplaying: cell, forItemAt: indexPath)
    }
  }
}
