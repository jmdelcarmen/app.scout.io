//
//  AppDelegate.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/10/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import UIKit
import KeychainAccess
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Instantiate Keychain
        let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
        do {
            let token = try keychain.get("token")
            if token != nil {
                let homeStoryboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
                let homeVC = homeStoryboard.instantiateInitialViewController()

                self.window?.rootViewController = homeVC
            }
        } catch {
            print("Error instantiating keychain")
        }
        
        // Instantiate Realm
        do {
            _ = try Realm()
        } catch {
            print("Error instantiating Realm")
        }
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
//        defaults.removeObject(forKey: "refetchMetadata")
        
        
        let defaults = UserDefaults.standard

        if defaults.object(forKey: "refetchMetadata") == nil {
            let dict = [
                "recommendations": ["shouldRefetch": true, "refetchedAt": NSDate()],
                "discoveries": ["shouldRefetch": true, "refetchedAt": NSDate()],
                "visits": ["shouldRefetch": true, "refetchedAt": NSDate()],
            ]

            defaults.set(dict, forKey: "refetchMetadata")
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

