//
//  SeparatedVideoViewController.swift
//  LiveLikeDemoApp
//
//  Created by Mike M on 7/24/19.
//

import AVKit
import EngagementSDK
import UIKit

class SeparatedVideoViewController: UIViewController {
    // MARK: EngagementSDK Properties

    private let minChatWidth: CGFloat = 292.0
    private var session: ContentSession?
    private let widgetViewController = WidgetPopupViewController()

    private let tabBarViewController = TabBarTableViewController()
    private var portraitChatBG: UIColor = UIColor(red: 36.0 / 256.0, green: 40.0 / 256.0, blue: 44.0 / 256.0, alpha: 1.0)
    let avPlayerViewController = AVPlayerViewController()
    
    // MARK: ViewController Properties

    private var isLandscapeMode: Bool {
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            return true
        }
        return false
    }

    private var landscapeWidgetViewLeading: NSLayoutConstraint?
    var timeObserver: Any?
    lazy var dateFormatter: DateFormatter = {
        DateFormatter.currentTimeZoneTime
    }()

    private var portraitConstraints: [NSLayoutConstraint] = Array()
    private var landscapeConstraints: [NSLayoutConstraint] = Array()

    // MARK: - UI Elements

    private var widgetView: UIView = UIView()

    private var chatView: UIView = UIView()

//    private let videoPlayer: AVPlayer = {
//        if let streamURL = EngagementSDKConfigManager.shared.selectedProgram?.streamURL {
//            let videoPlayer: AVPlayer = AVPlayer(url: streamURL)
//            return videoPlayer
//        }
//        return AVPlayer()
//    }()

    private let videoPlayer: AVPlayer = AVPlayer(url : URL(string: "https://websdk.livelikecdn.com/demo/manchestervid.mp4")!)
    
    private let videoPlayerView: UIView = {
        let videoPlayerView: UIView = UIView(frame: CGRect.zero)
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerView.backgroundColor = .clear
        return videoPlayerView
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

    let backButton: UIButton = {
        let backButton = UIButton(frame: .zero)
//        backButton.setTitle("<- Event: \(EngagementSDKConfigManager.shared.selectedProgram?.title ?? "[NONE]")", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonAction(sender:)), for: .touchUpInside)
        backButton.setTitleColor(.green, for: .normal)
        return backButton
    }()


    let buttonsStack: UIStackView = {
        let buttonsStack = UIStackView(frame: .zero)
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .vertical
        buttonsStack.alignment = .leading
        buttonsStack.distribution = .fillEqually
        return buttonsStack
    }()

    let setUsernameButton: UIButton = {
        let userImageButton: UIButton = UIButton(frame: .zero)
        userImageButton.translatesAutoresizingMaskIntoConstraints = false
        userImageButton.setTitle("Set Username", for: .normal)
        userImageButton.addTarget(self, action: #selector(setUsername), for: .touchUpInside)
        userImageButton.setTitleColor(.green, for: .normal)
        return userImageButton
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    //private let sdk: EngagementSDK
   // private let programID: String

//    init() {
////        self.sdk = sdk
////        self.programID = programID
//        super.init(nibName: nil, bundle: nil)
//    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setUpViews() {
        view.backgroundColor = .white
        view.addSubview(videoPlayerView)
        view.addSubview(chatView)
        view.addSubview(widgetView)
        view.addSubview(videoTimerLabel)
    }

    private func setUpLayout() {
        let portraitVideoPlayerHeight = videoPlayerView.heightAnchor.constraint(equalTo: videoPlayerView.widthAnchor, multiplier: 9 / 16)
        portraitVideoPlayerHeight.priority = UILayoutPriority(rawValue: 999)

        portraitConstraints = [
            portraitVideoPlayerHeight,
            widgetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chatView.topAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: 0.0),
            chatView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
        ]

        landscapeConstraints = [
            videoPlayerView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            widgetView.leadingAnchor.constraint(equalTo: chatView.leadingAnchor, constant: 0),
            chatView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0.0),
            chatView.widthAnchor.constraint(equalToConstant: minChatWidth)
        ]

        videoPlayerView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0.0).isActive = true
        videoPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        videoPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true

//        buttonsStack.topAnchor.constraint(equalTo: videoPlayerView.topAnchor, constant: 5.0).isActive = true
//        buttonsStack.leadingAnchor.constraint(equalTo: videoPlayerView.leadingAnchor, constant: 10.0).isActive = true
//        buttonsStack.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: -40).isActive = true
//        buttonsStack.widthAnchor.constraint(equalToConstant: view.frame.size.width - 10).isActive = true

        
        widgetView.topAnchor.constraint(equalTo: chatView.topAnchor, constant: 0.0).isActive = true
        widgetView.widthAnchor.constraint(equalTo: chatView.widthAnchor).isActive = true
        widgetView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -60.0).isActive = true

        chatView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        chatView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0.0).isActive = true

        videoTimerLabel.widthAnchor.constraint(equalToConstant: 75.0).isActive = true
        videoTimerLabel.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: -5).isActive = true
        videoTimerLabel.trailingAnchor.constraint(equalTo: videoPlayerView.trailingAnchor, constant: -5).isActive = true
    }

    private func setUpVideoPlayer() {
        avPlayerViewController.player = videoPlayer
        avPlayerViewController.showsPlaybackControls = true

        avPlayerViewController.view.frame = CGRect(x: 0, y: 0, width: videoPlayerView.bounds.width, height: videoPlayerView.bounds.height)
        videoPlayerView.addSubview(avPlayerViewController.view)
        addChild(avPlayerViewController)

        videoPlayer.play()
    }

    // MARK: - UIViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpEngagementSDKLayout()

        setUpViews()
        setUpLayout()

        setUpVideoPlayer()

        addTapGestureToVideoView()

        addNSNotificationObservers()
        addPDTObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshOrientationMode(isLandscape: isLandscapeMode)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        refreshOrientationMode(isLandscape: UIDevice.current.orientation.isLandscape)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UIButton Actions

    @objc func backButtonAction(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

   

    @objc func setUsername() {
        let alert = UIAlertController(
            title: "Change User Display Name",
            message: "Limit of 20 characters",
            preferredStyle: .alert
        )
        alert.addTextField(configurationHandler: nil)

        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let self = self else { return }

            guard
                let newNickname = alert.textFields?.first?.text,
                (1 ... 100).contains(newNickname.count)
            else {
                self.presentErrorAlert(for: "Invalid display name")
                return
            }

//            self.sdk.setUserDisplayName(newNickname) { [weak self] in
//                guard let self = self else { return }
//                if case let .failure(error) = $0 {
//                    self.presentErrorAlert(for: error.localizedDescription)
//                }
//            }
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    private func presentErrorAlert(for errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Tap Gesture Functionality

extension SeparatedVideoViewController {
    private func addTapGestureToVideoView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        videoPlayerView.addGestureRecognizer(tap)
    }

    @objc private func videoTapped() {
        if isLandscapeMode {
            if chatView.isHidden {
                chatView.isHidden = false
            } else {
                chatView.isHidden = true
            }
        }
    }
}

// MARK: - NSNotification

extension SeparatedVideoViewController {
    @objc func appDidBecomeActive() {
        if let livePosition = avPlayerViewController.player?.currentItem?.seekableTimeRanges.last as? CMTimeRange {
            avPlayerViewController.player?.seek(to: CMTimeRangeGetEnd(livePosition))
        }
        avPlayerViewController.player?.play()
        widgetViewController.resume()
    }

    @objc func appWillResignActive() {
        avPlayerViewController.player?.pause()
        widgetViewController.pause()
    }

    private func addNSNotificationObservers() {

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

    
}

// MARK: - Engagement SDK Functionality

extension SeparatedVideoViewController {
    private func setUpEngagementSDKLayout() {
        // Add widgetViewController as child view controller
        addChild(widgetViewController)
        widgetViewController.didMove(toParent: self)

        widgetView = widgetViewController.view
        widgetView.translatesAutoresizingMaskIntoConstraints = false

        // Add chatViewController as a child view controller
        addChild(tabBarViewController)
        chatView.addSubview(tabBarViewController.view)
        tabBarViewController.didMove(toParent: self)

        chatView = tabBarViewController.view
        tabBarViewController.view.translatesAutoresizingMaskIntoConstraints = false

//        let config = SessionConfiguration(
//            programID: programID,
//            chatHistoryLimit: 10,
//            widgetConfig: WidgetConfigManager.shared.currentConfig
//        )
//        config.syncTimeSource = { [weak self] in
//            self?.avPlayerViewController.player?.programDateTime.timeIntervalSince1970
//        }
//        sdk.createContentSession(config: config) { [weak self] in
//            guard let self = self else { return }
//            switch $0 {
//            case let .failure(error):
//                log.dev(error.localizedDescription)
//            case let .success(session):
//                self.session = session
//                self.chatViewController.session = session
//                self.chatViewController.shouldDisplayDebugVideoTime = true
//                self.widgetViewController.session = session
//            }
//        }
    }

    /// Per design landscape chatview needs to be transparent and when returning to portrait
    /// mode, we need to resume the previous background color
    private func enableLandscapeChatView(isLandscape: Bool) {
        if isLandscape {
            chatView.backgroundColor = .clear
            //tabBarViewController.setTheme(.overlay)
        } else {
            chatView.isHidden = false // always show chat view in Portrait mode
            //tabBarViewController.setTheme(.dark)
        }
    }
}

extension SeparatedVideoViewController {
    func addPDTObserver() {
        let time = CMTimeMake(value: 1, timescale: 4)
        timeObserver = avPlayerViewController.player?.addPeriodicTimeObserver(forInterval: time, queue: nil, using: { [weak self] _ in
            guard let date = self?.avPlayerViewController.player?.currentItem?.currentDate() else {
                return
            }
            self?.videoTimerLabel.text = self?.dateFormatter.string(from: date)
        })
    }

    func removePDTObserver() {
        if let timeObserver = timeObserver {
            avPlayerViewController.player?.removeTimeObserver(timeObserver)
        }
    }
}

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }

    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }

    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }

    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        }
        return trailingAnchor
    }

    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        }
        return leadingAnchor
    }
}
