//
//  UIView+with.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 16.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

protocol HasWith: AnyObject {}

extension HasWith {

   func with(_ closure: (Self) throws -> Void) rethrows -> Self {
      try closure(self)
      return self
   }
}

extension UIView: HasWith {}

public func disableBackButtonContextMenu(_ vc: UIViewController) {
   if #available(iOS 14.0, *) {
      vc.navigationItem.backBarButtonItem = BackBarButtonItem.make()
   } else {
      vc.navigationItem.backButtonTitle = ""
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
