//
//  AppDelegate.swift
//  Example-iOS
//
//  Created by Oleg Ketrar on 29.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
   var window: UIWindow?

   func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
   ) -> Bool {

      // Override point for customization after application launch.
      return true
   }

   func application(
      _ application: UIApplication,
      configurationForConnecting connectingSceneSession: UISceneSession,
      options: UIScene.ConnectionOptions
   ) -> UISceneConfiguration {

      return UISceneConfiguration(
         name: "default",
         sessionRole: connectingSceneSession.role)
   }
}
