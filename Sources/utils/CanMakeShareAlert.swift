//
//  CanMakeShareAlert.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

protocol CanMakeShareAlert {}

extension CanMakeShareAlert {

   func makeShareVC(for activityItem: Any) -> UIViewController {

      let shareVC = UIActivityViewController(
         activityItems: [activityItem],
         applicationActivities: nil)

      shareVC.excludedActivityTypes = [
         .addToReadingList,
         .assignToContact,
         .openInIBooks,
         .postToFacebook,
         .postToTencentWeibo,
         .postToFlickr,
         .postToWeibo,
         .postToVimeo,
         .postToTwitter,
         .saveToCameraRoll
      ]

      return shareVC
   }
}
