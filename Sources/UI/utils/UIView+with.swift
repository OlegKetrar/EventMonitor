//
//  UIView+with.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 16.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

public protocol HasWith: AnyObject {}

extension HasWith {

   public func with(_ closure: (Self) throws -> Void) rethrows -> Self {
      try closure(self)
      return self
   }
}

extension UIView: HasWith {}

extension UIViewController {

   public func disableBackButtonContextMenu() {
      if #available(iOS 14.0, *) {
         navigationItem.backBarButtonItem = BackBarButtonItem.make()
      } else {
         navigationItem.backButtonTitle = ""
      }
   }
}

private class BackBarButtonItem: UIBarButtonItem {

   static func make() -> BackBarButtonItem {
      BackBarButtonItem(title: "", style: .plain, target: nil, action: nil)
   }

   @available(iOS 14.0, *)
   override var menu: UIMenu? {
      get { super.menu }
      set {}
   }
}
