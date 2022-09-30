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

public struct NetworkEventConfig<CustomEvent: CustomNetworkEvent> {
   private var customActions: [AnyEventContextAction<CustomEvent>]

   init() {
      customActions = []
   }

   public func addAction(_ action: some EventContextAction<CustomEvent>) -> Self {
      var copy = self
      copy.customActions.append(AnyEventContextAction(action))

      return copy
   }
}

extension NetworkEventConfig: EventConfiguration {

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

      let share = ShareFileAction<CustomEvent>(
         title: "Share .log",
         configuration: self)

      return [AnyEventContextAction(share)] + customActions
   }
}

extension NetworkEventConfig: SharingConfiguration {

   public func format(event: CustomEvent) -> String {
      PlainTextFormatter().format(event: event.networkData)
   }

   public func makeFileName(event: CustomEvent) -> String {
      event.networkData.makeFileName()
   }
}

extension NetworkEvent {

   public func makeFileName() -> String {
      "\(request.verb)\(request.method).log"
         .replacingOccurrences(of: "/", with: "_")
         .lowercased()
   }
}
