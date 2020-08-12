//
//  AppDelegate.swift
//  FirstApp
//
//  Created by Nghia NH on 8/10/20.
//  Copyright © 2020 Tab21. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        let nvc = UINavigationController(rootViewController: mainViewController)
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle


}

