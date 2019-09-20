//
//  EventDetailsPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import Dispatch

final class EventDetailsPresenter: Presenter, CanMakeShareAlert {
   let event: ActivityEvent

   init(event: ActivityEvent) {
      self.event = event
   }

   func share(_ completion: @escaping () -> Void) {

      makeLogFile(for: event) { [weak self] in
         guard let strongSelf = self else { return }
         completion()

         guard let path = $0 else { return }

         strongSelf.navigationController?.present(
            strongSelf.makeShareVC(for: URL(fileURLWithPath: path)),
            animated: true)
      }
   }
}

private extension EventDetailsPresenter {

   func makeLogFile(
      for event: ActivityEvent,
      _ completion: @escaping (String?) -> Void) {

      DispatchQueue.global().async {

         let exportDir = NSTemporaryDirectory()
            .ns
            .appendingPathComponent("network-monitor.exporting-logs")

         let filePath = exportDir.ns.appendingPathComponent(event.fileName)

         FileManager.default.createDirectoryIfNotExist(at: exportDir)

         let fileContent = PlainTextFormatter()
            .format(event: event)
            .data(using: .utf8)

         let writedSuccessfully = FileManager.default.createFile(
            atPath: filePath,
            contents: fileContent)

         DispatchQueue.main.async {
            completion(writedSuccessfully ? filePath : nil)
         }
      }
   }
}

private extension ActivityEvent {

   var fileName: String {
      return "\(request.verb)\(request.method).log"
         .replacingOccurrences(of: "/", with: "_")
         .lowercased()
   }
}
