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
      options connectionOptions: UIScene.ConnectionOptions
   ) {

      guard let scene = (scene as? UIWindowScene) else { return }

      window = UIWindow(windowScene: scene)
      window?.rootViewController = UINavigationController(rootViewController: ViewController())
      window?.makeKeyAndVisible()
   }
}
