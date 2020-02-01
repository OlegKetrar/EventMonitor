//
//  TrackableViewController.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 10.03.2020.
//  Copyright © 2020 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

enum Screen {
   case sessionList
   case session
   case eventDetails
}

/// Abstract UIViewController which can track appearance of subclasses.
/// Each subclass MUST override `screen` property.
class TrackableViewController: UIViewController {
   static var onDidAppear: (Screen) -> Void = { _ in }

   override func viewDidLoad() {
      super.viewDidLoad()
      Self.onDidAppear(screen)
   }

   /// MUST be overridden by subclasses.
   var screen: Screen { fatalError() }
}
