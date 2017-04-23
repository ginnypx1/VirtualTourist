//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Ginny Pennekamp on 4/23/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    
    var window: UIWindow?
    let stack = CoreDataStack(modelName: "Model")!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        stack.autoSave(30)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // save when the application is about to move from active to inactive state.
        do {
            try stack.saveContext()
        } catch {
            print("There was an error saving the app data in WillResignActive.")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // save when app moves to the background
        do {
            try stack.saveContext()
        } catch {
            print("There was an error saving the app data in WillResignActive.")
        }
    }


}

