//
//  ProblemViewController.swift
//  YTPlayer-Test
//
//  Created by Sivda on 2/6/2020.
//

import UIKit

class ProblemViewController: UIViewController {
  private let videoId_1 = "YbgnlkJPga4"
  private let videoId_2 = "QImCld9YubE"

  private let descriptionContainerView = UIView()
  private let descriptionLabel = UILabel()
  private let videoCellStatusLabel_1 = UILabel()
  private let videoCellStatusLabel_2 = UILabel()
  private var childCellTypes: [VideoListViewController.CellType] = []
  private(set) var child: VideoListViewController!
  weak var delegate: VideoListViewControllerDelegate?
  
  private var isVideoCell_1_Visible: Bool = false {
    didSet {
      if isVideoCell_1_Visible {
        videoCellStatusLabel_1.textColor = .systemGreen
        videoCellStatusLabel_1.text = "Video Cell 1 is visible"
      } else {
        videoCellStatusLabel_1.textColor = .systemRed
        videoCellStatusLabel_1.text = "Video Cell 1 is NOT visible"
      }
    }
  }

  private var isVideoCell_2_Visible: Bool = false {
    didSet {
      if isVideoCell_2_Visible {
        videoCellStatusLabel_2.textColor = .systemGreen
        videoCellStatusLabel_2.text = "Video Cell 2 is visible"
      } else {
        videoCellStatusLabel_2.textColor = .systemRed
        videoCellStatusLabel_2.text = "Video Cell 2 is NOT visible"
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    childCellTypes = [
      .normal,
      .video(id: videoId_1),
      .normal,
      .video(id: videoId_2),
      .normal
    ]
    
    descriptionContainerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(descriptionContainerView)
    NSLayoutConstraint.activate([
      descriptionContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      descriptionContainerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      descriptionContainerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
    ])
    
    descriptionLabel.numberOfLines = 0
    descriptionLabel.font = UIFont.systemFont(ofSize: 16)
    descriptionLabel.text = "Try interact with the video player and then scroll to see how to delegate events change"
    descriptionLabel.textAlignment = .center
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionContainerView.addSubview(descriptionLabel)
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 13),
      descriptionLabel.leftAnchor.constraint(equalTo: descriptionContainerView.leftAnchor, constant: 13),
      descriptionLabel.rightAnchor.constraint(equalTo: descriptionContainerView.rightAnchor, constant: -13)
    ])
    
    videoCellStatusLabel_1.numberOfLines = 0
    videoCellStatusLabel_1.font = UIFont.systemFont(ofSize: 16)
    videoCellStatusLabel_1.textAlignment = .center
    videoCellStatusLabel_1.translatesAutoresizingMaskIntoConstraints = false
    descriptionContainerView.addSubview(videoCellStatusLabel_1)
    NSLayoutConstraint.activate([
      videoCellStatusLabel_1.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 13),
      videoCellStatusLabel_1.leftAnchor.constraint(equalTo: descriptionContainerView.leftAnchor, constant: 13),
      videoCellStatusLabel_1.rightAnchor.constraint(equalTo: descriptionContainerView.rightAnchor, constant: -13)
    ])
    
    videoCellStatusLabel_2.numberOfLines = 0
    videoCellStatusLabel_2.font = UIFont.systemFont(ofSize: 16)
    videoCellStatusLabel_2.textAlignment = .center
    videoCellStatusLabel_2.translatesAutoresizingMaskIntoConstraints = false
    descriptionContainerView.addSubview(videoCellStatusLabel_2)
    NSLayoutConstraint.activate([
      videoCellStatusLabel_2.topAnchor.constraint(equalTo: videoCellStatusLabel_1.bottomAnchor, constant: 4),
      videoCellStatusLabel_2.leftAnchor.constraint(equalTo: descriptionContainerView.leftAnchor, constant: 13),
      videoCellStatusLabel_2.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: -13),
      videoCellStatusLabel_2.rightAnchor.constraint(equalTo: descriptionContainerView.rightAnchor, constant: -13)
    ])

    child = VideoListViewController(cellTypes: childCellTypes)
    child.delegate = self
    addChild(child)
    child.view.translatesAutoresizingMaskIntoConstraints = false
    child.collectionView.contentInset = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
    view.addSubview(child.view)
    NSLayoutConstraint.activate([
      child.view.topAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor),
      child.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      child.view.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
    child.didMove(toParent: self)
    
    isVideoCell_1_Visible = false
    isVideoCell_2_Visible = false
  }
}

// MARK: - VideoListViewControllerDelegate

extension ProblemViewController: VideoListViewControllerDelegate {
  func controller(_ controller: VideoListViewController, willDisplay cell: VideoListViewCell, forItemAt indexPath: IndexPath) {
    switch cell.videoId {
    case videoId_1:
      isVideoCell_1_Visible = true
    case videoId_2:
      isVideoCell_2_Visible = true
    default:
      break
    }
    delegate?.controller(controller, willDisplay: cell, forItemAt: indexPath)
  }
  
  func controller(_ controller: VideoListViewController, didEndDisplaying cell: VideoListViewCell, forItemAt indexPath: IndexPath) {
    switch cell.videoId {
    case videoId_1:
      isVideoCell_1_Visible = false
    case videoId_2:
      isVideoCell_2_Visible = false
    default:
      break
    }
    delegate?.controller(controller, didEndDisplaying: cell, forItemAt: indexPath)
  }
}
