//
//  AppDelegate.swift
//  SDKDemo
//
//  Created by Changdeo Jadhav on 05/08/21.
//

import UIKit
import EngagementSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var engagementSDK: EngagementSDK!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var config = EngagementSDKConfig(clientID: "jV2LSongmdccPRL65M8GC6Z8lTievPsRsqsoSMiq")
        engagementSDK = EngagementSDK(config: config)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

