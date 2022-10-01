//
//  UIView+with.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 01.10.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import UIKit

protocol HasWith: AnyObject {}

extension HasWith {

   func with(_ closure: (Self) throws -> Void) rethrows -> Self {
      try closure(self)
      return self
   }
}

extension UIView: HasWith {}
