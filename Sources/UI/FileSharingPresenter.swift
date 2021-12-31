//
//  FileSharingPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit

struct FileSharingPresenter {

   func shareFile(at path: String?, presentOver vc: UIViewController?) {
      vc?.present(
         makeAlertForFile(at: path),
         animated: true,
         completion: nil)
   }

   private func makeAlertForFile(at path: String?) -> UIViewController {

      guard let filePath = path else {
         return makeErrorAlert()
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

      // TODO: use callback to remove tmp files

      return shareVC
   }

   private func makeErrorAlert() -> UIAlertController {

      let alert = UIAlertController(
         title: "Can't share file",
         message: nil,
         preferredStyle: .alert)

      let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
         alert.dismiss(animated: true, completion: nil)
      })

      alert.addAction(ok)

      return alert
   }
}
