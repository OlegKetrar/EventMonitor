//
//  Monitor.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

public final class Monitor {
   private static let monitor = NetworkMonitor()
   private static var screen: Screen = .sessionList

   public static func log(event: ActivityEvent) {
      monitor.log(event: event)
   }

   public static func show(on vc: UIViewController) {
      TrackableViewController.tracker = { self.screen = $0 }

      let listVC = SessionListVC()
      let nc = UINavigationController(rootViewController: listVC)

      listVC.presenter = SessionListPresenter
         .init(sessions: monitor.getObservableActivitySessions())
         .with(navigationController: nc)

      vc.present(nc, animated: true, completion: nil)
   }

   public static func push(into nc: UINavigationController) {
      TrackableViewController.tracker = { self.screen = $0 }

      let listVC = SessionListVC()
      listVC.presenter = SessionListPresenter
         .init(sessions: monitor.getObservableActivitySessions())
         .with(navigationController: nc)

      nc.pushViewController(listVC, animated: true)
   }
}

enum Screen {
   case sessionList
   case session      // id
   case eventDetails // id
}

class TrackableViewController: UIViewController {
   fileprivate static var tracker: (Screen) -> Void = { _ in }

   override func viewDidLoad() {
      super.viewDidLoad()
      Self.tracker(screen)
   }

   var screen: Screen { fatalError() }
}
