//
//  NetworkEventConfig.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorUI
import MonitorCore

extension MonitorUI.NetworkEvent: Event {}

struct NetworkEventConfig: EventConfiguration {
   typealias Event = MonitorUI.NetworkEvent

   enum NetworkEventAction: String, CaseIterable, EventContextAction {

      case shareLog = "Copy log"
      case cUrl = "Copy cURL"
      case tasteIt = "Test it"

      var title: String {
         rawValue
      }

      var image: UIImage {
         let img: UIImage?

         switch self {
         case .shareLog:
            img = UIImage(systemName: "square.and.arrow.up")
         case .cUrl:
            img = UIImage(systemName: "doc.circle.fill")
         case .tasteIt:
            img = UIImage(systemName: "play.circle")
         }

         return img ?? UIImage()
      }

      func perform(
         _ event: MonitorUI.NetworkEvent,
         navigation: UINavigationController?
      ) async throws {

         switch self {
         case .shareLog:
            let exporter = FileExporter(formatter: PlainTextFormatter())

            let file = await exporter.prepareFile(
               named: event.makeFileName(),
               content: { $0.format(event: event) })

            await MainActor.run {
               FileSharingPresenter(filePath: file?.path)
                  .share(over: navigation, completion: {
                     // let arc to remove file from disk
                     _ = file
                  })
            }

         case .cUrl:
            try await Task.sleep(nanoseconds: 1_000_000_000)

         case .tasteIt:
            try await Task.sleep(nanoseconds: 1_000_000_000)
         }

         debugPrint("-- done: \(self.title)")
      }
   }

   func configure(cell: NetworkEventCell, event: MonitorUI.NetworkEvent) -> NetworkEventCell {
      cell.with(verb: event.request.verb.uppercased())
      cell.with(request: event.request.method)
      cell.with(success: event.response.failureReason == nil)

      return cell
   }

   func buildDetailView(
      event: MonitorUI.NetworkEvent,
      menuItems: [any MonitorUI.EventMenuItem],
      navigation: UINavigationController?
   ) -> UIViewController? {

      let menuConfig = MenuBuilder
         .init(items: menuItems)
         .makeConfiguration(navigation)

      return NetworkEventDetailsVC(
         viewModel: NetworkEventViewModel(event),
         menuConfiguration: menuConfig)
   }

   var actions = NetworkEventAction.allCases

   func format(event: NetworkEvent) -> String {
      PlainTextFormatter().format(event: event)
   }
}

private extension NetworkEvent {

   func makeFileName() -> String {
      "\(request.verb)\(request.method).log"
         .replacingOccurrences(of: "/", with: "_")
         .lowercased()
   }
}
