//
//  HavePreloaderButton.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 16.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

/// Provides ActivityIndicator as UIBarButtonItem.
@objc protocol HavePreloaderButton: AnyObject {}

extension HavePreloaderButton {

   func configuredPreloaderBarButton(tint color: UIColor = .gray) -> UIBarButtonItem {

      return UIBarButtonItem(customView: {
         let preloader = UIActivityIndicatorView(style: .gray)
         preloader.color = color
         preloader.startAnimating()
         return preloader
      }())
   }
}
