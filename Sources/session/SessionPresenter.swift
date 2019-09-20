//
//  SessionPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import Dispatch

final class SessionPresenter: Presenter, CanMakeShareAlert {
   var session: Observable<ActivitySession>

   init(session: Observable<ActivitySession>) {
      self.session = session
   }

   func selectEvent(at index: Int) {
      guard session.value.events.indices.contains(index) else { return }

      let vc = EventDetailsVC()
      vc.presenter = EventDetailsPresenter
         .init(event: session.value.events[index])
         .with(navigationController: navigationController)

      navigationController?.pushViewController(vc, animated: true)
   }

   func share(_ completion: @escaping () -> Void) {

      makeLogFile(for: session.value) { [weak self] in
         guard let strongSelf = self else { return }
         completion()

         guard let path = $0 else {
            strongSelf.navigationController?.show(
               strongSelf.makeAlert(message: "Can't share log file"),
               sender: strongSelf)

            return
         }

         strongSelf.navigationController?.present(
            strongSelf.makeShareVC(for: URL(fileURLWithPath: path)),
            animated: true)
      }
   }
}

private extension SessionPresenter {

   func makeLogFile(
      for session: ActivitySession,
      _ completion: @escaping (String?) -> Void) {

      DispatchQueue.global().async {

         let exportDir = NSTemporaryDirectory()
            .ns
            .appendingPathComponent("network-monitor.exporting-logs")

         let filePath = exportDir
            .ns
            .appendingPathComponent("\(session.title).log")

         FileManager.default.createDirectoryIfNotExist(at: exportDir)

         let formatter = PlainTextFormatter()

         let fileContent = session.events
            .map { "--> \( formatter.format(event: $0) )" }
            .joined(separator: "\n\n")
            .data(using: .utf8)

         let writedSuccessfully = FileManager.default.createFile(
            atPath: filePath,
            contents: fileContent)

         DispatchQueue.main.async {
            completion(writedSuccessfully ? filePath : nil)
         }
      }
   }

   func makeAlert(message: String) -> UIAlertController {

      let alert = UIAlertController(
         title: message,
         message: nil,
         preferredStyle: .alert)

      let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
         alert.dismiss(animated: true, completion: nil)
      })

      alert.addAction(ok)

      return alert
   }
}
