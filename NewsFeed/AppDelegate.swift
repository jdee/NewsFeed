//
//  AppDelegate.swift
//  NewsFeed
//
//  Created by Jimmy Dee on 12/14/18.
//  Copyright © 2018 Dubsar Dictionary Project. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set ViewController as the root VC of the NC
        guard let nc = window?.rootViewController as? UINavigationController else {
            fatalError("root VC is not a navigation controller")
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewController.identifier)
        
        nc.pushViewController(vc, animated: false)

        return true
    }

}

