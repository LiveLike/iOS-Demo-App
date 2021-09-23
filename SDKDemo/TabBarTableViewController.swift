//
//  TabBarTableViewController.swift
//  SDKDemo
//
//  Created by Changdeo Jadhav on 05/08/21.
//

import UIKit

class TabBarTableViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }

   

    fileprivate func createNavController(for rootViewController: UIViewController,
                                                     title: String) -> UIViewController {
           let navController = UINavigationController(rootViewController: rootViewController)
           navController.tabBarItem.title = title
           navController.isNavigationBarHidden = true
        return navController
       }
    
    func setTheme() {
        
    }
    
    func setupVCs() {
            viewControllers = [
                createNavController(for: ChatViewControllerContainer(), title: NSLocalizedString("Chat", comment: "") ),
                createNavController(for: TimelineViewController(), title: NSLocalizedString("Timeline", comment: "")),
                
            ]
        }
}
