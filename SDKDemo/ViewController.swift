//
//  ViewController.swift
//  SDKDemo
//
//  Created by Changdeo Jadhav on 05/08/21.
//

import AVKit
import EngagementSDK
import UIKit

class ViewController: UIViewController {

    var tabBarViewController: TabBarTableViewController = TabBarTableViewController()
    let avPlayerViewController = AVPlayerViewController()
    let adPlayer = AdsPlayer()
    private var isAdPlaying: Bool = false
    private var portraitConstraints: [NSLayoutConstraint] = Array()
    private var landscapeConstraints: [NSLayoutConstraint] = Array()
    private let minChatWidth: CGFloat = 292.0
    
    private var isLandscapeMode: Bool {
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            return true
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(adPlayerView)
        view.addSubview(videoPlayerView)
        addChild(tabBarViewController)
        tabBarViewController.didMove(toParent: self)
        // Apply constraints to the `chatViewController.view`
        view.addSubview(tabBarViewController.view)
        tabBarViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        setUpLayout()
        setUpVideoPlayer()

    }

    private func setUpLayout() {
        let portraitVideoPlayerHeight = videoPlayerView.heightAnchor.constraint(equalTo: videoPlayerView.widthAnchor, multiplier: 9 / 16)
        portraitVideoPlayerHeight.priority = UILayoutPriority(rawValue: 999)

        portraitConstraints = [
            portraitVideoPlayerHeight,
            tabBarViewController.view.topAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: 0.0),
           tabBarViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
        ]

        landscapeConstraints = [
            videoPlayerView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            tabBarViewController.view.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0.0),
            tabBarViewController.view.widthAnchor.constraint(equalToConstant: minChatWidth)
        ]

        videoPlayerView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0.0).isActive = true
        videoPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        videoPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true

       

        adPlayerView.topAnchor.constraint(equalTo: videoPlayerView.topAnchor, constant: 0.0).isActive = true
        adPlayerView.trailingAnchor.constraint(equalTo: videoPlayerView.trailingAnchor, constant: 0.0).isActive = true
        adPlayerView.leadingAnchor.constraint(equalTo: videoPlayerView.leadingAnchor, constant: 0.0).isActive = true
        adPlayerView.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: 0.0).isActive = true
       
        tabBarViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        tabBarViewController.view.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0.0).isActive = true

        
    }
    
    private let videoPlayer: AVPlayer = AVPlayer(url : URL(string: "https://websdk.livelikecdn.com/demo/manchestervid.mp4")!)
    
    private let videoPlayerView: UIView = {
        let videoPlayerView: UIView = UIView(frame: CGRect.zero)
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerView.backgroundColor = .clear
        return videoPlayerView
    }()

    private let adPlayerView: UIView = {
        let adPlayerView: UIView = UIView(frame: CGRect.zero)
        adPlayerView.translatesAutoresizingMaskIntoConstraints = false
        adPlayerView.backgroundColor = .clear
        return adPlayerView
    }()

    let videoTimerLabel: UILabel = {
        let videoTimerLabel = UILabel(frame: .zero)
        videoTimerLabel.backgroundColor = UIColor(red: 36.0 / 256.0, green: 40.0 / 256.0, blue: 44.0 / 256.0, alpha: 0.6)
        videoTimerLabel.textColor = .white
        videoTimerLabel.text = "[UNAVAILABLE]"
        videoTimerLabel.textAlignment = .center
        videoTimerLabel.font = UIFont.systemFont(ofSize: 13)
        videoTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        videoTimerLabel.accessibilityIdentifier = "label_video_timer"
        return videoTimerLabel
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshOrientationMode(isLandscape: isLandscapeMode)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        refreshOrientationMode(isLandscape: UIDevice.current.orientation.isLandscape)
    }
    
    private func refreshOrientationMode(isLandscape: Bool) {
        enableLandscapeChatView(isLandscape: isLandscape)

        if isLandscape {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
            buttonsStack.isHidden = true
        } else {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
            buttonsStack.isHidden = false
        }
    }

    /// Per design landscape chatview needs to be transparent and when returning to portrait
    /// mode, we need to resume the previous background color
    private func enableLandscapeChatView(isLandscape: Bool) {
        if isLandscape {
            tabBarViewController.view.backgroundColor = .clear
            //tabBarViewController.setTheme(.overlay)
        } else {
            tabBarViewController.view.isHidden = false // always show chat view in Portrait mode
            //tabBarViewController.setTheme(.dark)
        }
    }
    
    let playAdButton: UIButton = {
        let playAdButton = UIButton(frame: .zero)
        playAdButton.setTitle("Play Ad", for: .normal)
        playAdButton.setTitle("Stop Ad", for: .selected)
        playAdButton.translatesAutoresizingMaskIntoConstraints = false
        playAdButton.addTarget(self, action: #selector(toggleAd(sender:)), for: .touchUpInside)
        playAdButton.setTitleColor(.green, for: .normal)
        return playAdButton
    }()

    @objc func toggleAd(sender: UIButton) {
        if playAdButton.isSelected {
            playAdButton.isSelected = false
            adPlayer.pauseAd()
            adFinished()
        } else {
            playAdButton.isSelected = true
            avPlayerViewController.player?.pause()
            adPlayer.playAd()
            adStarted()
        }
    }
    
    
    let buttonsStack: UIStackView = {
        let buttonsStack = UIStackView(frame: .zero)
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .vertical
        buttonsStack.alignment = .leading
        buttonsStack.distribution = .fillEqually
        return buttonsStack
    }()
    private func setUpVideoPlayer() {
        avPlayerViewController.player = videoPlayer
        avPlayerViewController.showsPlaybackControls = true

        avPlayerViewController.view.frame = CGRect(x: 0, y: 0, width: videoPlayerView.bounds.width, height: videoPlayerView.bounds.height)
        videoPlayerView.addSubview(avPlayerViewController.view)
        addChild(avPlayerViewController)

        adPlayer.view.frame = CGRect(x: 0, y: 0, width: videoPlayerView.bounds.width, height: videoPlayerView.bounds.height)
        adPlayerView.addSubview(adPlayer.view)
        addChild(adPlayer)

        videoPlayer.play()
    }
}

extension ViewController {
    @objc func appDidBecomeActive() {
        if let livePosition = avPlayerViewController.player?.currentItem?.seekableTimeRanges.last as? CMTimeRange {
            avPlayerViewController.player?.seek(to: CMTimeRangeGetEnd(livePosition))
        }
        adFinished()
        avPlayerViewController.player?.play()
   //     widgetViewController.resume()
    }

    @objc func appWillResignActive() {
        avPlayerViewController.player?.pause()
    //    widgetViewController.pause()
    }

    private func addNSNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adStarted),
            name: AdService.adStartedNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adFinished),
            name: AdService.adFinishedNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    private func removeNSNotificationObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func adStarted() {
        avPlayerViewController.view.alpha = 0
        avPlayerViewController.player?.volume = 0
        avPlayerViewController.player?.pause()
        isAdPlaying = true
       // session?.pause()
    }

    @objc func adFinished() {
        avPlayerViewController.view.alpha = 1
        avPlayerViewController.player?.volume = 1
        avPlayerViewController.player?.play()
        isAdPlaying = false
        //session?.resume()
    }
}

//extension UIView {
//    var safeTopAnchor: NSLayoutYAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return self.safeAreaLayoutGuide.topAnchor
//        }
//        return topAnchor
//    }
//
//    var safeLeftAnchor: NSLayoutXAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return self.safeAreaLayoutGuide.leftAnchor
//        }
//        return leftAnchor
//    }
//
//    var safeRightAnchor: NSLayoutXAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return self.safeAreaLayoutGuide.rightAnchor
//        }
//        return rightAnchor
//    }
//
//    var safeBottomAnchor: NSLayoutYAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return self.safeAreaLayoutGuide.bottomAnchor
//        }
//        return bottomAnchor
//    }
//
//    var safeTrailingAnchor: NSLayoutXAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return self.safeAreaLayoutGuide.trailingAnchor
//        }
//        return trailingAnchor
//    }
//
//    var safeLeadingAnchor: NSLayoutXAxisAnchor {
//        if #available(iOS 11.0, *) {
//            return self.safeAreaLayoutGuide.leadingAnchor
//        }
//        return leadingAnchor
//    }
//}

extension ViewController {
    private func addTapGestureToVideoView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        videoPlayerView.addGestureRecognizer(tap)
    }

    @objc private func videoTapped() {
        if isLandscapeMode {
            if tabBarViewController.view.isHidden {
                tabBarViewController.view.isHidden = false
            } else {
                tabBarViewController.view.isHidden = true
            }
        }
    }
}

