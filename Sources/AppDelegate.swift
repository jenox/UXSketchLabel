//
//  AppDelegate.swift
//  UXSketchLabel
//
//  Created by Christian Schnorr on 17.02.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = ViewController()

        self.window = window

        window.makeKeyAndVisible()

        return true
    }
}
