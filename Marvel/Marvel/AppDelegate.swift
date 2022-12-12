//
//  AppDelegate.swift
//  Marvel
//
//  Created by user225687 on 10/27/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let ViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: ViewController)

        window.rootViewController = navigationController
 
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}

