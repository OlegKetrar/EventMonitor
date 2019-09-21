//
//  FileSharingTrait.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import Dispatch

protocol FileSharingTrait {}

extension FileSharingTrait {

   func shareFile(
      name: String,
      content: @escaping () -> String,
      completion: @escaping (UIViewController?) -> Void) {

      DispatchQueue.global().async {

         let exportDir = NSTemporaryDirectory()
            .ns
            .appendingPathComponent("network-monitor.exporting-logs")

         let filePath = exportDir.ns.appendingPathComponent(name)

         FileManager.default.createDirectoryIfNotExist(at: exportDir)

         let writedSuccessfully = FileManager.default.createFile(
            atPath: filePath,
            contents: content().data(using: .utf8))

         DispatchQueue.main.async {
            guard writedSuccessfully else {
               completion(nil)
               return
            }

            let shareVC = UIActivityViewController(
               activityItems: [URL(fileURLWithPath: filePath)],
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

            completion(shareVC)
         }
      }
   }
}
