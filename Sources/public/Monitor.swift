//
//  Monitor.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

public protocol Logger {
   func log(event: ActivityEvent)
}

public final class Monitor {
   private static let monitor = NetworkMonitor()
   private static var screen: Screen = .sessionList

   /// We create another UIWindow to have a callback on shakeEvent.
   private static var motionWindow: MotionWindow?

   /// Enables Monitor presenting on shake gesture.
   /// - parameter rootVC: root view controller of your app. Monitor will be presented onto this vc.
   public static func enableShakeToShow(rootViewController rootVC: UIViewController) {
      guard motionWindow == nil else { return }

      motionWindow = MotionWindow(frame: .zero)
      motionWindow?.backgroundColor = .clear
      motionWindow?.windowLevel = .normal

      motionWindow?.motionCallback = { [weak rootVC] motion in
         guard let rootVC = rootVC,
            motion == .motionShake else { return }

         let allSessions = monitor.getObservableActivitySessions()
         let listVC = SessionListVC()
         let nc = UINavigationController(rootViewController: listVC)

         listVC.presenter = SessionListPresenter
            .init(isPresented: true, sessions: allSessions)
            .with(navigationController: nc)

         if let activeSession = allSessions.first {

            let sessionVC = SessionVC()
            sessionVC.presenter = SessionPresenter
               .init(session: activeSession)
               .with(navigationController: nc)

            nc.setViewControllers([listVC, sessionVC], animated: false)
         }

         rootVC.present(nc, animated: true, completion: nil)
      }

      motionWindow?.makeKeyAndVisible()
   }

   public static func disableShakeToShow() {
      motionWindow?.motionCallback = { _ in }
      motionWindow = nil
   }

   public static func makeLogger(subsystem: String) -> Logger {
      NetworkMonitorLogger {
         monitor.log(event: $0, domain: subsystem)
      }
   }

   public static func log(event: ActivityEvent) {
      monitor.log(event: event, domain: "default")
   }

   public static func show(on vc: UIViewController) {
      TrackableViewController.onDidAppear = { self.screen = $0 }

      let listVC = SessionListVC()
      let nc = UINavigationController(rootViewController: listVC)

      listVC.presenter = SessionListPresenter
         .init(isPresented: true, sessions: monitor.getObservableActivitySessions())
         .with(navigationController: nc)

      vc.present(nc, animated: true, completion: nil)
   }

   public static func push(into nc: UINavigationController) {
      TrackableViewController.onDidAppear = { self.screen = $0 }

      let listVC = SessionListVC()
      listVC.presenter = SessionListPresenter
         .init(isPresented: false, sessions: monitor.getObservableActivitySessions())
         .with(navigationController: nc)

      nc.pushViewController(listVC, animated: true)
   }
}

private class NetworkMonitorLogger: Logger {
   private let logFunction: (ActivityEvent) -> Void

   init(_ logFunction: @escaping (ActivityEvent) -> Void) {
      self.logFunction = logFunction
   }

   func log(event: ActivityEvent) {
      DispatchQueue.main.async {
         self.logFunction(event)
      }
   }
}

private class MotionWindow: UIWindow {
   var motionCallback: (UIEvent.EventSubtype) -> Void = { _ in }

   override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
      super.motionBegan(motion, with: event)
      motionCallback(motion)
   }
}
