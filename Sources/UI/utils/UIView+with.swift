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
