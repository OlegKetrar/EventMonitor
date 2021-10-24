//
//  FileSharingPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit

struct FileSharingPresenter {

   func shareFile(
      name: String,
      content: @escaping () -> String,
      completion: @escaping (UIViewController) -> Void
   ) {

      // TODO: remove tmp files

      FileWritter().writeFile(
         name: name,
         content: content,
         completion: { filePath in

            guard let filePath = filePath else {
               completion(makeErrorAlert())
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
         })
   }

   private func makeErrorAlert() -> UIAlertController {

      let alert = UIAlertController(
         title: "Can't share log file",
         message: nil,
         preferredStyle: .alert)

      let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
         alert.dismiss(animated: true, completion: nil)
      })

      alert.addAction(ok)

      return alert
   }
}
