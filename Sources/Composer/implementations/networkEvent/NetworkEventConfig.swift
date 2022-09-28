//
//  NetworkEventConfig.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorUI
import MonitorCore
import class UIKit.UIViewController
import class UIKit.UINavigationController

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

   public var actions: [AnyEventContextAction<CustomEvent>] {
      [
         AnyEventContextAction(HelloWorldAction()),
         AnyEventContextAction(ShareAction(configuration: self))
      ]
   }
}

extension NetworkEventConfig: SharingConfiguration {

   public func format(event: CustomEvent) -> String {
      PlainTextFormatter().format(event: event.networkData)
   }

   public func makeFileName(event: CustomEvent) -> String {
      let request = event.networkData.request

      return "\(request.verb)\(request.method).log"
         .replacingOccurrences(of: "/", with: "_")
         .lowercased()
   }
}
