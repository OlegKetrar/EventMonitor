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

extension NetworkEvent: Event {}

public protocol CustomNetworkEvent: Event {
   var networkData: NetworkEvent { get }
}

extension NetworkEvent: CustomNetworkEvent {
   public var networkData: NetworkEvent { self }
}

public struct NetworkEventConfig<CustomEvent: CustomNetworkEvent>: EventConfiguration {
   public typealias Event = CustomEvent

   public func configure(cell: NetworkEventCell, event: CustomEvent) -> NetworkEventCell {
      let event = event.networkData

      cell.with(verb: event.request.verb.uppercased())
      cell.with(request: event.request.method)
      cell.with(success: event.response.failureReason == nil)

      return cell
   }

   public func buildDetailView(
      event: CustomEvent,
      menuItems: [any MonitorUI.EventMenuItem],
      navigation: UINavigationController?
   ) -> UIViewController? {

      let menuConfig = MenuBuilder
         .init(items: menuItems)
         .makeConfiguration(navigation)

      return NetworkEventDetailsVC(
         viewModel: NetworkEventViewModel(event.networkData),
         menuConfiguration: menuConfig)
   }

   public var actions = NetworkEventAction<CustomEvent>.allCases

   public func format(event: CustomEvent) -> String {
      PlainTextFormatter().format(event: event.networkData)
   }
}

public enum NetworkEventAction<CustomEvent: CustomNetworkEvent>: String, CaseIterable, EventContextAction {

   case shareLog = "Copy log"
   case cUrl = "Copy cURL"
   case tasteIt = "Test it"

   public var title: String {
      rawValue
   }

   public var image: UIImage {
      let img: UIImage? = {
         switch self {
         case .shareLog: return UIImage(systemName: "square.and.arrow.up")
         case .cUrl: return UIImage(systemName: "doc.circle.fill")
         case .tasteIt: return UIImage(systemName: "play.circle")
         }
      }()

      return img ?? UIImage()
   }

   public func perform(
      _ event: CustomEvent,
      navigation: UINavigationController?
   ) async throws {

      switch self {
      case .shareLog:
         let exporter = FileExporter(formatter: PlainTextFormatter())

         let file = await exporter.prepareFile(
            named: event.networkData.makeFileName(),
            content: { $0.format(event: event.networkData) })

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

private extension NetworkEvent {

   func makeFileName() -> String {
      "\(request.verb)\(request.method).log"
         .replacingOccurrences(of: "/", with: "_")
         .lowercased()
   }
}
