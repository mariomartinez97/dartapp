//
//  ChannelsViewController.swift
//  FriendlyChatSwift
//
//  Created by Mario Miguel on 10/12/16.
//  Copyright © 2016 Google Inc. All rights reserved.
//

import UIKit

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        return true
    }
}
