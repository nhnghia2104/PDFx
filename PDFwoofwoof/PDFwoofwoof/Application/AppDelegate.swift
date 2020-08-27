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
        
        var mainViewController : UIViewController?
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
        if UserDefaults.standard.object(forKey: "MainView") == nil {
            UserDefaults.standard.setValue(1, forKey: "MainView")
        }
        if let key = UserDefaults.standard.object(forKey: "MainView") as? Int {
            switch key {
            case 1:
                mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                break
            case 2 :
                mainViewController = storyboard.instantiateViewController(withIdentifier: "DocumentsVC") as! DocumentsVC
                break
            default:
                mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                break
            }
        }
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController!)
        
        UINavigationBar.appearance().tintColor = CMSConfigConstants.themeStyle.tintColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.getFontOpenSans(style: .SemiBold, size: 14)], for: .normal)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController: nvc , leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        
        slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
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
        createDefaultFolder()
    }
    
    func createDefaultFolder() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderPath = documentDirectory.appendingPathComponent("Downloaded")

        if !FileManager.default.checkFileExists(url: folderPath) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }

        //save pdf default
        if UserDefaults.standard.object(forKey: "createDefaultFolder") == nil {
            
            
            guard let path = Bundle.main.url(forResource: "pdf-sample", withExtension: "pdf") else { return }
            let document = path
            let needTo = document.startAccessingSecurityScopedResource()
            do {
                let data = try Data(contentsOf: path)
                try data.write(to: documentDirectory.appendingPathComponent("pdf-sample.pdf"))
                UserDefaults.standard.setValue(true, forKey: "createDefaultFolder")
            }
            catch {
                
            }
            if needTo {
                document.stopAccessingSecurityScopedResource()
            }
            
        }
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.createMenuView()
       
        var config = Realm.Configuration()
        config.fileURL = inLibraryFolder(fileName: "default.realm")
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm(configuration: config)
        print("Realm Path : \(String(describing: realm.configuration.fileURL?.absoluteURL))")
        return true
    }
    func inLibraryFolder(fileName : String) -> URL {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }
    
    func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Ensure the URL is a file URL
        guard inputURL.isFileURL else { return false }
        guard let rootView = window?.rootViewController else { return false }

        let storyboard = UIStoryboard(name: "PDFDocument", bundle: nil)
        
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        
        let pdfVC = navigationController.viewControllers.first as! PDFViewController
        pdfVC.config(with: Document(fileURL: inputURL))
        
        navigationController.modalTransitionStyle = .crossDissolve
        // Presenting modal in iOS 13 fullscreen
        navigationController.modalPresentationStyle = .fullScreen
        rootView.present(navigationController, animated: true, completion: nil)

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
        // khi quay lai aphahahahah
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // khi quay lai app
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    
}

