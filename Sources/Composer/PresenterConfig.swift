//
//  PresenterConfig.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import UIKit
import MonitorUI

public final class PresenterConfig {
   private let viewFactory: () -> MonitorView

   init(viewFactory: @escaping () -> MonitorView) {
      self.viewFactory = viewFactory
   }

   public func show(over viewController: UIViewController?) {
      viewFactory().present(over: viewController)
   }

   public func push(into navigationController: UINavigationController?) {
      viewFactory().push(into: navigationController)
   }

   /// Enables Monitor presenting on shake gesture.
   /// - parameter rootViewController: root view controller of your app.
   /// Monitor will be presented onto this vc.
   public func enableShakeToShow(rootViewController: UIViewController) {
      motionCallback = { [weak rootViewController, weak self] in
         guard
            let strongSelf = self,
            let rootVC = rootViewController
         else { return }

         strongSelf.viewFactory().presentActiveSession(over: rootVC)
      }
   }

   public func disableShakeToShow() {
      motionCallback = nil
   }
}

private var motionCallback: (() -> Void)?

extension UIWindow {

   override open func motionBegan(
      _ motion: UIEvent.EventSubtype,
      with event: UIEvent?
   ) {

      super.motionBegan(motion, with: event)

      if event?.type == .motion {
         motionCallback?()
      }
   }
}
