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
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

      // Override point for customization after application launch.
      return true
   }

   @available(iOS 13.0, *)
   func application(
      _ application: UIApplication,
      configurationForConnecting connectingSceneSession: UISceneSession,
      options: UIScene.ConnectionOptions) -> UISceneConfiguration {

      return UISceneConfiguration(
         name: "default",
         sessionRole: connectingSceneSession.role)
   }

   @available(iOS 13.0, *)
   func application(
      _ application: UIApplication,
      didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

      // Called when the user discards a scene session.
      // If any sessions were discarded while the application was not running,
      // this will be called shortly after application:didFinishLaunchingWithOptions.
      // Use this method to release any resources that were specific
      // to the discarded scenes, as they will not return.
   }
}
