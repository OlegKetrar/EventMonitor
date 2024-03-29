//
//  SceneDelegate.swift
//  Example-iOS
//
//  Created by Oleg Ketrar on 29.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   var window: UIWindow?

   func scene(
      _ scene: UIScene,
      willConnectTo session: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions) {

      // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
      // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
      // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
      guard let _ = (scene as? UIWindowScene) else { return }
   }
}
