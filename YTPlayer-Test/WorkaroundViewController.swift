//
//  WorkaroundViewController.swift
//  YTPlayer-Test
//
//  Created by Sivda on 2/6/2020.
//

import UIKit

private class DisplayLinkHandler {
  private weak var displayLink: CADisplayLink?
  var didStep: ((CADisplayLink) -> Void)?

  init() {
    let displayLink = CADisplayLink(target: self, selector: #selector(displayDidStep(dlink:)))
    displayLink.add(to: .main, forMode: .common)
    self.displayLink = displayLink
  }

  func invalidate() {
    displayLink?.invalidate()
  }

  @objc
  func displayDidStep(dlink: CADisplayLink) {
    didStep?(dlink)
  }
}

class WorkaroundViewController: UIViewController {
  private let descriptionContainerView = UIView()
  private let descriptionLabel = UILabel()
  private var displayLinkHandler: DisplayLinkHandler?

  private(set) var child: ProblemViewController!
  private var videoCells: [VideoListViewCell] = []

  deinit {
    displayLinkHandler?.invalidate()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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

    child = ProblemViewController()
    addChild(child)
    child.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(child.view)
    NSLayoutConstraint.activate([
      child.view.topAnchor.constraint(equalTo: view.topAnchor),
      child.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      child.view.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
    child.didMove(toParent: self)
    child.delegate = self

    displayLinkHandler = DisplayLinkHandler()
    displayLinkHandler?.didStep = { [weak self] link in
      self?.displayDidStep(displaylink: link)
    }
  }

  @objc
  func displayDidStep(displaylink: CADisplayLink) {
    var index = 0
    while index < videoCells.count {
      let cell = videoCells[index]
      if !child.child.collectionView.bounds.intersects(cell.frame) {
        cell.playerView.pauseVideo()
        cell.unbindVideoPlayerView()
        videoCells.remove(at: index)
        continue
      }

      index += 1
    }
  }
}

extension WorkaroundViewController: VideoListViewControllerDelegate {
  func controller(_ controller: VideoListViewController, willDisplay cell: VideoListViewCell, forItemAt indexPath: IndexPath) {
    cell.bindVideoPlayerView()
    videoCells.append(cell)
  }
  
  func controller(_ controller: VideoListViewController, didEndDisplaying cell: VideoListViewCell, forItemAt indexPath: IndexPath) {
  }
}
