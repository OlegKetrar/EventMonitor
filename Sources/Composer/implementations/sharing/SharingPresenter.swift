//
//  SharingPresenter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit

public struct SharingPresenter {

   enum Resource {
      case file(LocalFileRef)
      case plainText(String)
      case error(String)
   }

   let resource: Resource

   public init(file: LocalFileRef?) {
      if let file {
         self.resource = .file(file)
      } else {
         self.resource = .error("Can't share file")
      }
   }

   public init(plainText str: String?) {
      if let str {
         self.resource = .plainText(str)
      } else {
         self.resource = .error("Can't share text")
      }
   }

   public func share(
      over rootViewController: UIViewController?,
      completion: @escaping () -> Void = {}
   ) {

      let viewController: UIViewController

      switch resource {
      case let .file(file):
         viewController = makeSharingAlert(file: file, completion: completion)

      case let .plainText(text):
         viewController = makeSharingAlert(text: text, completion: completion)

      case let .error(message):
         viewController = makeErrorAlert(title: message, completion: completion)
      }

      rootViewController?.present(viewController, animated: true)
   }

   func makeSharingAlert(
      file: LocalFileRef,
      completion: @escaping () -> Void
   ) -> UIViewController {

      let shareVC = UIActivityViewController(
         activityItems: [URL(fileURLWithPath: file.path)],
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

         // let arc to remove file from disk
         _ = file
      }

      return shareVC
   }

   func makeSharingAlert(
      text: String,
      completion: @escaping () -> Void
   ) -> UIViewController {

      let shareVC = UIActivityViewController(
         activityItems: [text],
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

   func makeErrorAlert(
      title: String,
      completion: @escaping () -> Void
   ) -> UIAlertController {

      let alert = UIAlertController(
         title:  title,
         message: nil,
         preferredStyle: .alert)

      let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
         alert.dismiss(animated: true, completion: completion)
      })

      alert.addAction(ok)

      return alert
   }
}
