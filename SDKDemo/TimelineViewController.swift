//
//  TimelineViewController.swift
//  SDKDemo
//
//  Created by Changdeo Jadhav on 09/08/21.
//

import UIKit
import EngagementSDK

class TimelineViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let sdk = appDelegate.engagementSDK
        
        let config = SessionConfiguration(programID: "9baf1962-f7db-43b9-ae8e-b84f1bf31988")
        let contentSession = sdk?.contentSession(config: config)
        let timelineVC = InteractiveWidgetTimelineViewController(contentSession: contentSession as! ContentSession)
        
        // Do any additional setup after loading the view.
        // Add timelineVC to layout
        addChild(timelineVC)
        timelineVC.didMove(toParent: self)
        timelineVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timelineVC.view)
        
        // Apply layout constraints
        NSLayoutConstraint.activate([
            timelineVC.view.topAnchor.constraint(equalTo: view.topAnchor),
          timelineVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          timelineVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          timelineVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
      }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


