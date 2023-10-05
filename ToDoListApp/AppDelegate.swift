//
//  AppDelegate.swift
//  ToDoListApp
//
//  Created by Sai Prasad on 01/10/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: ToDoListViewController())
        self.window?.makeKeyAndVisible()
        return true
    }
}

