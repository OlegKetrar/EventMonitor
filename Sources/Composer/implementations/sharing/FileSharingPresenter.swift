//
//  FileSharingPresenter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit

struct FileSharingPresenter {
   let filePath: String?

   func share(
      over vc: UIViewController?,
      completion: @escaping () -> Void
   ) {

      vc?.present(
         makeAlert(completion),
         animated: true,
         completion: nil)
   }

   private func makeAlert(_ completion: @escaping () -> Void) -> UIViewController {

      guard let existingFilePath = filePath else {
         return makeErrorAlert(completion)
      }

      let shareVC = UIActivityViewController(
         activityItems: [URL(fileURLWithPath: existingFilePath)],
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
         completion()
      }

      return shareVC
   }

   private func makeErrorAlert(_ completion: @escaping () -> Void) -> UIAlertController {

      let alert = UIAlertController(
         title: "Can't share file",
         message: nil,
         preferredStyle: .alert)

      let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
         alert.dismiss(animated: true, completion: completion)
      })

      alert.addAction(ok)

      return alert
   }
}
