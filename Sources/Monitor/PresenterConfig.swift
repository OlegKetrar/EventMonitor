//
//  PresenterConfig.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import UIKit
import MonitorCore
import MonitorUI

public final class PresenterConfig {
   private let getEventProvider: () -> EventProvider

   /// We create another UIWindow to have a callback on shakeEvent.
   private var motionWindow: MotionWindow?

   init(provider: @autoclosure @escaping () -> EventProvider) {
      self.getEventProvider = provider
   }

   public func show(over viewController: UIViewController) {
//      MonitorPresenter
//         .init(repository: getEventProvider())
//         .present(over: viewController)
   }

   public func push(into navigationController: UINavigationController) {
//      MonitorPresenter
//         .init(repository: getEventProvider())
//         .push(into: navigationController)
   }

   /// Enables Monitor presenting on shake gesture.
   /// - parameter rootViewController: root view controller of your app.
   /// Monitor will be presented onto this vc.
   public func enableShakeToShow(rootViewController: UIViewController) {
      guard motionWindow == nil else { return }

      motionWindow = MotionWindow(frame: .zero)
      motionWindow?.backgroundColor = .clear
      motionWindow?.windowLevel = .normal

      motionWindow?.motionCallback = { [weak rootViewController, weak self] motion in
         guard
            let strongSelf = self,
            let rootVC = rootViewController,
            motion == .motionShake
         else { return }

//         MonitorPresenter
//            .init(repository: strongSelf.getEventProvider())
//            .presentCurrentSession(over: rootVC)
      }

      motionWindow?.makeKeyAndVisible()
   }

   public func disableShakeToShow() {
      motionWindow?.motionCallback = { _ in }
      motionWindow = nil
   }
}

private class MotionWindow: UIWindow {
   var motionCallback: (UIEvent.EventSubtype) -> Void = { _ in }

   override func motionBegan(
      _ motion: UIEvent.EventSubtype,
      with event: UIEvent?
   ) {
      super.motionBegan(motion, with: event)
      motionCallback(motion)
   }
}
