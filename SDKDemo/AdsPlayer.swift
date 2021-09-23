//
//  AdsVideoPlayerViewController.swift
//  LiveLikeDemo
//
//

import AVKit
import UIKit

class AdsPlayer: UIViewController {
    private var adPlayer: AVQueuePlayer?
    private var adPlayerLayer: AVPlayerLayer?
    private lazy var adPlayerItems: [AVPlayerItem] = {
        guard let url = Bundle.main.url(forResource: "sample_ad", withExtension: "mp4") else {
            return []
        }
        return [AVPlayerItem(url: url)]
    }()

    private lazy var removeAdsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove Ads", for: .normal)
        button.addTarget(self, action: #selector(adDidFinish), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
        addObservers()
        addButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let playerLayer = adPlayerLayer else { return }
        playerLayer.frame = view.bounds
    }

    private func setupVideo() {
        adPlayer = AVQueuePlayer(items: adPlayerItems)
        adPlayerLayer = AVPlayerLayer(player: adPlayer)

        guard let playerLayer = adPlayerLayer else { return }
        playerLayer.videoGravity = .resizeAspectFill

        view.layer.addSublayer(playerLayer)
        playerLayer.isHidden = true

        adPlayer?.actionAtItemEnd = .none
        adPlayer?.seek(to: .zero)
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adDidFinish),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: adPlayerItems.last
        )
    }

    private func addButtons() {
        view.addSubview(removeAdsButton)

        let constraints = [
            removeAdsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            removeAdsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    @objc private func adDidFinish() {
        NotificationCenter.default.post(name: AdService.adFinishedNotification, object: nil)

        guard let playerLayer = adPlayerLayer else { return }
        playerLayer.isHidden = true

        adPlayer?.pause()
        adPlayer?.seek(to: .zero)
    }

    @objc func pauseAd() {
        adPlayer?.pause()
    }

    @objc func playAd() {
        NotificationCenter.default.post(name: AdService.adStartedNotification, object: nil)

        adPlayerLayer?.isHidden = false

        adPlayer?.play()
    }
}
