//
//  AppDelegate.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/10/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    fileprivate func createMenuView() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC

        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = CMSConfigConstants.themeStyle.gray1
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController: nvc , leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true

        slideMenuController.delegate = mainViewController
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        //create file
//        let file = "\(UUID().uuidString).txt"
//        let content = "hello world"
//        let direct = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileURL = direct.appendingPathComponent(file)
//        do {
//            try content.write(to: fileURL, atomically: false, encoding: .utf8)
//        }
//        catch {
//            print("tạch :(")
//        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.createMenuView()
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
           // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
           // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
       }
       
       func applicationDidEnterBackground(_ application: UIApplication) {
           // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
           // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       }
       
       func applicationWillEnterForeground(_ application: UIApplication) {
           // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
       }
       
       func applicationDidBecomeActive(_ application: UIApplication) {
           // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       }
       
       func applicationWillTerminate(_ application: UIApplication) {
           // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
           // Saves changes in the application's managed object context before the application terminates.
       }


}

