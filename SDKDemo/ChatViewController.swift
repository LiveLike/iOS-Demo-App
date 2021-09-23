//
//  ChatViewController.swift
//  SDKDemo
//
//  Created by Changdeo Jadhav on 06/08/21.
//

import UIKit
import EngagementSDK

class ChatViewControllerContainer: UIViewController, ContentSessionDelegate {
    func playheadTimeSource(_ session: ContentSession) -> Date? {
        return Date()
    }
    
    func session(_ session: ContentSession, didChangeStatus status: SessionStatus) {
        
    }
    
    func session(_ session: ContentSession, didReceiveError error: Error) {
    
    }
    
    func chat(session: ContentSession, roomID: String, newMessage message: ChatMessage) {
        
    }
    
    func widget(_ session: ContentSession, didBecomeReady widget: Widget) {
    
    }
    
    func contentSession(_ session: ContentSession, didReceiveWidget widget: WidgetModel) {
        
    }
    

    let chatViewController = ChatViewController()
    var session: ContentSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let sdk = appDelegate.engagementSDK
        
        // Add `chatViewController` as child view controller
            addChild(chatViewController)
            chatViewController.didMove(toParent: self)

            // Apply constraints to the `chatViewController.view`
            chatViewController.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(chatViewController.view)
            NSLayoutConstraint.activate([
                chatViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
                chatViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                chatViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                chatViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            //Creating a Content Session
            let config = SessionConfiguration(programID: "9baf1962-f7db-43b9-ae8e-b84f1bf31988")
            session = sdk?.contentSession(config: config)
            session?.delegate = self
            // Applying the Content Session to the Widget and Chat ViewControllers
            chatViewController.session = session
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
