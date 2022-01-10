//
//  FileSharingPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit
import MonitorCore

struct FileSharingPresenter {

   func share(file: LocalFileRef?, presentOver vc: UIViewController?) {
      vc?.present(
         makeAlertForFile(file),
         animated: true,
         completion: nil)
   }

   private func makeAlertForFile(_ file: LocalFileRef?) -> UIViewController {

      guard let existingFile = file else {
         return makeErrorAlert()
      }

      let shareVC = UIActivityViewController(
         activityItems: [URL(fileURLWithPath: existingFile.path)],
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

      shareVC.completionWithItemsHandler = { _, _, _, _ in

         // let arc to remove file from disk
         _ = file
      }

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
