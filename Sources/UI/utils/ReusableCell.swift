//
//  ReusableCell.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 16.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableCell: UITableViewCell {
   static var reuseIdentifier: String { get }
}

extension ReusableCell {

   static var reuseIdentifier: String {
      return String(describing: Self.self)
   }
}

extension UITableView {

   func register<T: ReusableCell>(cell: T.Type) {
      register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
   }

   func dequeue<T: ReusableCell>(cell: T.Type, for indexPath: IndexPath) -> T {
      if let cell = dequeueReusableCell(
         withIdentifier: T.reuseIdentifier,
         for: indexPath) as? T {

         return cell
      } else {
         fatalError("\(self) can't dequeue cell \(T.self)")
      }
   }
}
