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
@objc public protocol HavePreloaderButton: AnyObject {}

extension HavePreloaderButton {

   public func makePreloaderBarButton(tint color: UIColor = .gray) -> UIBarButtonItem {

      let preloader: UIActivityIndicatorView
      preloader = UIActivityIndicatorView(style: .medium)
      preloader.color = color
      preloader.startAnimating()

      return UIBarButtonItem(customView: preloader)
   }
}
