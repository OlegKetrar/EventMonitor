//
//  Presenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 22.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

class Presenter {
   private(set) weak var navigationController: UINavigationController?

   final func with(navigationController: UINavigationController?) -> Self {
      self.navigationController = navigationController
      return self
   }
}
